trigger NT_RelationshipTrigger on Relationship__c(after insert, after update) {
    
    IF ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
		NT_RelationshipTriggerHelperV4.RelationshipRollup(Trigger.new);
        
    }
    
}