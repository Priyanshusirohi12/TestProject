public without sharing class GreenDoorFileListCtrl {
	
    @AuraEnabled
    public static List <ContentVersion> getFilesForRecordId (String recordId) {
        
        System.debug ('>>>>> getFilesForRecordId: ' + recordId);
        List <ContentVersion> cvList = new List <ContentVersion> ();
        
    
        Set <Id> contentDocIds = new Set <Id> ();
        
        for (ContentDocumentLink cdl: [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ]) {
            contentDocIds.add(cdl.ContentDocumentId);
        }
        
        /*for (ContentVersion cv: [SELECT Id, PathOnClient, Title, FileType, ContentUrl, ContentSize  FROM ContentVersion 
                                 WHERE ContentDocumentId IN :contentDocIds AND IsLatest = true AND PublishStatus = 'P' ]) {*/
        for (ContentVersion cv: [SELECT Id, PathOnClient, Title, FileType, ContentUrl, ContentSize  FROM ContentVersion 
                                 WHERE ContentDocumentId IN :contentDocIds]) {                             
        	cvList.add (cv);
            
        }
        
        return cvList;
    }
}