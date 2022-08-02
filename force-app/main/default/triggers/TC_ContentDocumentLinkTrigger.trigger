trigger TC_ContentDocumentLinkTrigger on ContentDocumentLink (after insert, before insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        TC_ContentDocumentLinkTriggerHelper.createDists (Trigger.newMap);
        TC_ContentDocumentLinkTriggerHelper.updateAccountLogo (Trigger.newMap);
    }
}