trigger TC_Commission_Config on Commission_Config__c (before insert, before update) {
    if (Trigger.IsBefore) {
        TC_CommissionConfigTriggerHelper.validateUserLookups(Trigger.new);
    }
}