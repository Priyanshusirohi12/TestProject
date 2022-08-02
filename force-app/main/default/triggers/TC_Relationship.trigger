trigger TC_Relationship on Relationship__c (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        TC_RelationshipTriggerHelper.after (Trigger.old, Trigger.new);
    }
}