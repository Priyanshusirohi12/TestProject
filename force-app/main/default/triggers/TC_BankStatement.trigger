trigger TC_BankStatement on Bank_Statement__c (before insert, after insert) {

    if (Trigger.isAfter && Trigger.isInsert) {
        TC_BankStatementTriggerHelper.afterInsert (Trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isInsert) {
        TC_BankStatementTriggerHelper.beforeInsert (Trigger.new);
    }
}