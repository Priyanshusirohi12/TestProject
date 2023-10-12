/*
	Created by : Syed mehdi
	Created Date : Feb-03-2023

*/

Public class ProgramTriggerHandler{
    public static void afterInsert(List<Program__c> programList){
        //ProgramTriggerHelper.handlePicklistCount(programList);
        ProgramTriggerHelper.setSunRiseSunSetDateOnInsert(programList);
        ProgramTriggerHelper.validationAndSetProgramListOnInsert(programList);
    }
    public static void afterUpdate(List<Program__c> programList, Map<Id, Program__c> oldProgramMap){
    	//ProgramTriggerHelper.handlePicklistCount(programList);
        ProgramTriggerHelper.setSunRiseSunSetDateOnUpdate(programList, oldProgramMap);
        ProgramTriggerHelper.showCustomValidationOnUpdate(programList, oldProgramMap);
          
    }
    public static void afterDelete(List<Program__c> oldProgramList){
        //ProgramTriggerHelper.handlePicklistCount(oldProgramList);
        ProgramTriggerHelper.setSunRiseSunSetDateOnDelete(oldProgramList);
        ProgramTriggerHelper.updateProgramsListOnDelete(oldProgramList);
    }	
}


/*

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

*/