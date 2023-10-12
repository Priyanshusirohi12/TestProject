/*
	Created by : Syed mehdi
	Created Date : Feb-03-2023
	Decription : Store the count of Brand VOC field based on the Account and RecordType

*/
trigger ProgramTrigger on Program__c (After insert, after update, after delete) {
    if(Trigger.isInsert && Trigger.isAfter){
		ProgramTriggerHandler.afterInsert(Trigger.new);
    }     
    if(Trigger.isUpdate && Trigger.isAfter){
        if(!ProgramTriggerHelper.counter){
			ProgramTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    if(Trigger.isDelete && Trigger.isAfter){
        if(!ProgramTriggerHelper.counter){
			ProgramTriggerHandler.afterDelete(Trigger.old);
        }
    }
}