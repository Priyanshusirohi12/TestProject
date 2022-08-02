global without sharing class TC_CheckApprovalExpiredBatch implements Database.Batchable<sObject> {
    
    String query;

    global TC_CheckApprovalExpiredBatch () {
        query = 'SELECT Id FROM Opportunity WHERE Approval_Expired__c = true AND IsClosed = false AND Credit_Status__c != \'Approval Expired\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator (query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> opps) {     
        List <Opportunity> updateList = new List <Opportunity> ();
        
        for (Opportunity opp : opps) {
            updateList.add (new Opportunity (Id = opp.Id
                                            , Credit_Status__c = 'Approval Expired'));
        }
        
        update updateList;
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug ('Finished running TC_CheckApprovalExpired  ');
    }

}