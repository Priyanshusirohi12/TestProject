trigger TC_Equipment on Equipment__c (after insert, after update) {
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TC_EquipmentTriggerHelper.updateOppEquipDesc (null, Trigger.newMap);
        } else if (Trigger.isUpdate) {
            TC_EquipmentTriggerHelper.updateOppEquipDesc (Trigger.oldMap, Trigger.newMap);
        }
    }
}