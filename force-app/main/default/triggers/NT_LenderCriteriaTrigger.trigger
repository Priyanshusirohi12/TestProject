trigger NT_LenderCriteriaTrigger on LenderMatrix__Lender_Criteria__c (after insert, after update) {
    
    IF ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
        NT_LenderCriteriaTriggerHelper.LenderCriteriaRollup(Trigger.new);
        
    }
}