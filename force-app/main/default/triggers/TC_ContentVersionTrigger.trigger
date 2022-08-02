trigger TC_ContentVersionTrigger on ContentVersion (after insert) {
    
    if (Trigger.isAfter && Trigger.isInsert) {
        //TC_ContentVersionTriggerHelper.linkOnlineAppPDF(Trigger.newMap);
    }
    
}