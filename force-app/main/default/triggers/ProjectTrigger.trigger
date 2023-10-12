trigger ProjectTrigger on Project__c (before update,after update, after insert, before insert) {

    if(Trigger.isBefore && Trigger.isInsert){
        ProjectTriggerHelper.showErrorOnProjectInsert(Trigger.new);
      
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        ProjectTriggerHelper.toCreateProjectTask(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        if(Constants.upsertBreak){
            Constants.upsertBreak = false;
        	ProjectTriggerHelper.showErrorOnProjectUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
        }
    }
}