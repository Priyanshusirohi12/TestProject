/**
 * Created by eschneider on 10/23/20.
 */

public with sharing class TC_OnlineAppAddPDFHandler {
    public static void linkOnlineAppPDF(Map<Id, Online_Application_Add_PDF__e> triggerNew) {
        System.debug('<<< User:'+ UserInfo.getName());

        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<Id> docIds = new List<Id>();
        Map<String,String> cvMap = new Map<String, String>();
        for (Online_Application_Add_PDF__e ev : triggerNew.values()) {
            docIds.add(ev.Document_Id__c);
            cvMap.put(ev.Document_Id__c, ev.Parent_Record_Id__c);
        }
        List<ContentVersion> cvs = new List<ContentVersion>([SELECT Id, ContentDocumentId FROM Contentversion WHERE Id IN :docIds]);
        System.debug('<<<query: '+cvs);
        System.debug('<<<triggerNew: '+triggerNew);
        for (ContentVersion cd : cvs) {
            System.debug('<<< triggerNew: '+triggerNew.get(cd.Id));
            if(cvMap.get(cd.Id) != null && cvMap.get(cd.Id).startsWith('00Q')) {
                cdlList.add(new ContentDocumentLink(ContentDocumentId = cd.ContentDocumentId, ShareType = 'I', Visibility='AllUsers',
                        LinkedEntityId = cvMap.get(cd.Id)));
            }
        }

        if (cdlList.isEmpty()) {
            System.debug('<<<in empty list');
            return;
        }

        try {
            if (cdlList[0].getSObjectType().getDescribe().isCreateable()) {
                TC_OnlineApplicationUtility.CDLQueueable queue = new TC_OnlineApplicationUtility.CDLQueueable(cdlList);
                Id jobID = System.enqueueJob(queue);
            }
        } catch (Exception e){
            throw new DatabaseHandlerException('Error linking Online Application PDF');
        }

    }
    public class DatabaseHandlerException extends Exception {}
}