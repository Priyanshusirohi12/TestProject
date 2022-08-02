trigger TC_Lead on Lead (after update, after insert) {

    if (Trigger.isUpdate && Trigger.isAfter) {
        TC_LeadTriggerHelper.afterUpdate (Trigger.newMap, Trigger.oldMap);
        TC_LeadTriggerHelper.originatorEmailChanged (null, Trigger.newMap);
    }
    
    if (Trigger.isInsert && Trigger.isAfter) {
        TC_LeadTriggerHelper.originatorEmailChanged (Trigger.oldMap, Trigger.newMap);
    }
}