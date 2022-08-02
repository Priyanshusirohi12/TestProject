trigger TC_Commission on Commission__c (before insert, before update) {
    if (Trigger.IsBefore) {
        TC_CommissionTriggerHelper.checkCommissionConfigMatch(Trigger.new);
        TC_CommissionTriggerHelper.calculateNPV(Trigger.new);
    }
}