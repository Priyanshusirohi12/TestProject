public without sharing class TC_ContentVersionTriggerHelper {

	public static void linkOnlineAppPDF(Map <Id, ContentVersion> newMap) {

        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        
        for (ContentDocument cd : [SELECT Id, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId IN :newMap.keySet()]) {
            if(newMap.get(cd.LatestPublishedVersionId).Linked_Entity_Id__c != null && newMap.get(cd.LatestPublishedVersionId).Linked_Entity_Id__c.startsWith('00Q')) {
                cdlList.add(new ContentDocumentLink(ContentDocumentId = cd.Id, ShareType = 'V',
                                                   LinkedEntityId = newMap.get(cd.LatestPublishedVersionId).Linked_Entity_Id__c));
            }  
        }
        
        if (cdlList.isEmpty()) {
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