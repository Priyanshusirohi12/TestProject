trigger TC_Application_Condition on Application_Condition__c (before insert, before update) {
    if (Trigger.IsBefore) {
        TC_ApplicationConditionHelper.validateFields(Trigger.new);
    }
}