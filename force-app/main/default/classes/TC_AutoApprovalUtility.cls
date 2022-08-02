/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 03/01/2018
* @description: Utility class to simplify auto submitting, approving, and rejecting approval processes
*
* © Copyright 2003 - 2018 Tamarack Consulting, Inc.  All Rights Reserved.
*
*/

public class TC_AutoApprovalUtility {


    public Approval.ProcessResult submit;
    public Approval.ProcessResult approve;
    public List<Id> workItemIds = new List<Id> ();

    public String status;
    public String message;

    public Boolean skipEntryCriteria = FALSE;

    public String submitComment = 'AUTO SUBMIT';
    public String approveComment = 'AUTO APPROVE';


    public void submitToProcess (String processName, Id objId, Id userId) {

        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest ();
        request.setComments(submitComment);
        request.setObjectId(objId);

        // Submit on behalf of a specific submitter
        request.setSubmitterId(UserInfo.getUserId());

        request.setProcessDefinitionNameOrId(processName);
        request.setSkipEntryCriteria(skipEntryCriteria);

        request.setNextApproverIds(new Id[] {
            userId
        });

        system.debug('----submitting to = ' + processName);

        try {
            submit = Approval.process(request);
        } catch (Exception e) {
            system.debug('ERROR: ' + processName + '--' + e.getMessage());
            status = 'ERROR: ';
            message = e.getMessage();
        }

        system.debug('----submission result = ' + submit);


        if (submit <> NULL) {
            if (submit.isSuccess()) {
                status = 'SUCCESS';
                workItemIds = submit.getNewWorkitemIds();
            } else {
                status = 'ERROR';
                if (submit.getErrors().size() > 0) {
                    message = submit.getErrors()[0].getMessage();
                } else {
                    message = 'Unknown error';
                }

            }
        }
        system.debug('submit workItemIds = ' + workItemIds);
    }

    public void approveProcess (Id userId) {

        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest ();
        pwr.setComments(approveComment);
        pwr.setAction('Approve');
        pwr.setNextApproverIds(new Id[] {
            userId
        });
        system.debug('approve workItemIds = ' + workItemIds);
        if (!workItemIds.isEmpty()) {
            pwr.setWorkitemId(workItemIds.get(0));
    
            approve = Approval.process(pwr);
    
            if (approve.isSuccess()) {
                status = 'SUCCESS';
            } else {
                status = 'ERROR';
                if (submit.getErrors().size() > 0) {
                    message = submit.getErrors()[0].getMessage();
                } else {
                    message = 'Unknown error';
                }
    
            }
            
        }

    }

    public void rejectProcess (Id userId) {

        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest ();
        pwr.setComments(approveComment);
        pwr.setAction('Reject');
        pwr.setNextApproverIds(new Id[] {
            userId
        });
        system.debug('reject workItemIds = ' + workItemIds);
        if (!workItemIds.isEmpty()) {
            pwr.setWorkitemId(workItemIds.get(0));
            
            approve = Approval.process(pwr);
    
            if (approve.isSuccess()) {
                status = 'SUCCESS';
            } else {
                status = 'ERROR';
                if (submit.getErrors().size() > 0) {
                    message = submit.getErrors()[0].getMessage();
                } else {
                    message = 'Unknown error';
                }
    
            }
        }
    }

    public static List<approvalItem> getApprovalHistory (Id objId) {

        Map<String, String> icons = new Map<String, String> {
            'Pending' => 'standard:note',
            'Approved' => 'standard:task2',
            'Started' => 'standard:empty',
            'Rejected' => 'standard:entity_milestone'
        };

        Map<Id, approvalItem> approvalItems = new map<Id, approvalItem> ();
        Set<Id> userIds = new Set<Id> ();

        for (ProcessInstance pi : [
            SELECT
                Id,
                TargetObjectId,
                Status,
                CreatedDate,
                ProcessDefinitionId,
                CompletedDate,
                LastActorId, (
                SELECT
                    StepStatus,
                    ActorId,
                    Comments,
                    OriginalActorId,
                    ElapsedTimeInMinutes
                FROM Steps
                ORDER BY CreatedDate DESC
            ), (
                SELECT
                    Id,
                    ActorId,
                    ProcessInstanceId
                FROM Workitems
                ORDER BY CreatedDate DESC
            )
            FROM ProcessInstance
            WHERE TargetObjectId = :objId
            ORDER BY CreatedDate DESC
        ]) {


            approvalItem app = new approvalItem ();
            app.Id = pi.Id;
            app.TargetObjectId = pi.TargetObjectId;
            app.CreatedDate = pi.CreatedDate;
            app.Status = pi.Status;
            app.ProcessDefinitionId = pi.ProcessDefinitionId;
            app.CompletedDate = pi.CompletedDate;
            app.LastActorId = pi.LastActorId;
            app.iconName = icons.get(pi.Status);

            //collect users for later mapping
            userIds.add(pi.LastActorId);

            system.debug('ProcessInstance = ' + pi);

            app.Steps = new List<step> ();
            for (ProcessInstanceStep pis : pi.Steps) {
                system.debug('ProcessInstanceStep = ' + pis);
                step s = new step ();
                s.StepStatus = pis.StepStatus == 'Started' ? 'Submitted' : pis.StepStatus;
                s.ActorId = pis.ActorId;
                s.Comments = pis.Comments;
                s.OriginalActorId = pis.OriginalActorId;
                s.ElapsedTimeInMinutes = pis.ElapsedTimeInMinutes;
                s.iconName = icons.get(pis.StepStatus);
                app.Steps.add(s);

                //collect users for later mapping
                userIds.add(pis.ActorId);
                userIds.add(pis.OriginalActorId);
            }

            if (pi.Workitems.size() > 0) {
                system.debug('Workitems = ' + pi.Workitems);
                app.CurrentWorkItemId = pi.Workitems[0].Id;
                app.CurrentWorkItemActorId = pi.Workitems[0].ActorId;
                userIds.add(pi.Workitems[0].ActorId);
            }

            approvalItems.put(pi.Id, app);

        }

        //query and relate the processInstantNodes
        Set<Id> processInstanceIds = approvalItems.keySet();
        for (ProcessInstanceNode node : [
            SELECT
                Id,
                NodeStatus,
                ProcessNodeName,
                ProcessInstanceId
            FROM ProcessInstanceNode
            WHERE ProcessInstanceId IN:processInstanceIds
        ]) {
            approvalItem app = approvalItems.get(node.ProcessInstanceId);
            app.NodeStatus = node.NodeStatus;
            app.ProcessNodeName = node.ProcessNodeName;
            approvalItems.put(node.ProcessInstanceId, app);

        }

        //query and relate the user info
        Map<ID, User> userMap = new Map<ID, User> (
        [
            SELECT
                Id,
                FirstName,
                LastName
            FROM
                User
        ]
        );


        for (approvalItem app : approvalItems.values()) {

            if (userMap.get(app.LastActorId) <> NULL) {
                app.LastActorFirstName = userMap.get(app.LastActorId).FirstName;
                app.LastActorLastName = userMap.get(app.LastActorId).LastName;
            }
            if (userMap.get(app.CurrentWorkItemActorId) <> NULL) {
                app.CurrentWorkItemActorFirstName = userMap.get(app.CurrentWorkItemActorId).FirstName;
                app.CurrentWorkItemActorLastName = userMap.get(app.CurrentWorkItemActorId).LastName;
            }
            for (Step s : app.Steps) {
                if (userMap.get(s.ActorId) <> NULL) {
                    s.ActorFirstName = userMap.get(s.ActorId).FirstName;
                    s.ActorLastName = userMap.get(s.ActorId).LastName;
                }
                if (userMap.get(s.OriginalActorId) <> NULL) {
                    s.OriginalActorFirstName = userMap.get(s.OriginalActorId).FirstName;
                    s.OriginalActorLastName = userMap.get(s.OriginalActorId).LastName;
                }
            }

            system.debug('approvalItem = ' + app);
        }


        return approvalItems.values(); //return as List

    }


    public class approvalItem {
        @AuraEnabled
        public String TargetObjectId;
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public DateTime CreatedDate;
        @AuraEnabled
        public String Status;
        @AuraEnabled
        public Id ProcessDefinitionId;
        @AuraEnabled
        public DateTime CompletedDate;
        @AuraEnabled
        public Id LastActorId;
        @AuraEnabled
        public String LastActorFirstName;
        @AuraEnabled
        public String LastActorLastName;
        @AuraEnabled
        public String NodeStatus;
        @AuraEnabled
        public String ProcessNodeName;
        @AuraEnabled
        public List<step> Steps;
        @AuraEnabled
        public Id CurrentWorkItemId;
        @AuraEnabled
        public Id CurrentWorkItemActorId;
        @AuraEnabled
        public String CurrentWorkItemActorFirstName;
        @AuraEnabled
        public String CurrentWorkItemActorLastName;
        @AuraEnabled
        public String iconName = 'standard-account';
    }
    public class step {
        @AuraEnabled
        public String StepStatus;
        @AuraEnabled
        public Id ActorId;
        @AuraEnabled
        public String ActorFirstName;
        @AuraEnabled
        public String ActorLastName;
        @AuraEnabled
        public String Comments;
        @AuraEnabled
        public Id OriginalActorId;
        @AuraEnabled
        public String OriginalActorFirstName;
        @AuraEnabled
        public String OriginalActorLastName;
        @AuraEnabled
        public Double ElapsedTimeInMinutes;
        @AuraEnabled
        public Date CreatedDate;
        @AuraEnabled
        public String iconName = 'standard-account';
    }
}