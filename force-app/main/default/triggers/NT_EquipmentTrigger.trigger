trigger NT_EquipmentTrigger on Equipment__c (after insert, after update) {
    
    IF ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
        NT_EquipmentTriggerHelper.EquipmentRollup(Trigger.new);
        
    }
    
}