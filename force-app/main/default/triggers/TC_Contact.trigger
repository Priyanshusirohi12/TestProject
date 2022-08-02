trigger TC_Contact on Contact (after insert, after update) {

    if (Trigger.IsAfter) {
        if (Trigger.isInsert) {
            TC_ContactTriggerHelper.originatorTieToApp (null, Trigger.newMap);
            TC_ContactTriggerHelper.updateSSN(null, Trigger.newMap);
        } else if (Trigger.isUpdate) {
            TC_ContactTriggerHelper.originatorTieToApp (Trigger.oldMap, Trigger.newMap);
            TC_ContactTriggerHelper.updateSSN(Trigger.oldMap, Trigger.newMap);
        }
    }
}