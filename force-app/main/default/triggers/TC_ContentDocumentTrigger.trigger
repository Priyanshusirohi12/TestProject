trigger TC_ContentDocumentTrigger on ContentDocument (before delete) {

    if (Trigger.isBefore && Trigger.isDelete) {
        TC_ContentDocumentTriggerHelper.deleteAccountLogo(Trigger.oldMap);
    }

}