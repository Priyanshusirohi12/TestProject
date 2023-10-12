trigger ProjectTaskTrigger on Project_Task__c (before update ,after update) {
    
   List<Project_Task__c> projectTaskListToValidationList = new List<Project_Task__c>();
   List<Project_Task__c> ProjectTaskToNextValitionList = new List<Project_Task__c>();
    Set<Id> projectTaskIdsToValidatePreviousTask  = new Set<Id>();
    Set<Id> projectTaskIdsToValidateNextTask = new Set<Id>();
    
    for(Project_Task__c projectTask : Trigger.new){
             Boolean oldCompleted = Trigger.oldMap.get(projectTask.Id).Completed__c;
             if(projectTask.Completed__c != oldCompleted && Trigger.isBefore){
                 if(projectTask.Completed__c){
                     projectTaskListToValidationList.add(projectTask);
                     projectTaskIdsToValidatePreviousTask.add(projectTask.Id);
                 }else {
                     ProjectTaskToNextValitionList.add(projectTask);
                     projectTaskIdsToValidateNextTask.add(projectTask.Project__c);
                 }
             }
         }

     if(Trigger.isBefore){  
         for(Project_Task__c projectTask : ProjectTaskTriggerHelper.ProjectTaskToValidatePreviousTask(projectTaskIdsToValidatePreviousTask)){
         	Trigger.newMap.get(projectTask.Id).Completed__c.addError('Complete your previous task if your task is Completed');
         }		
         Project_task__c p = new Project_task__c();
         for(Project_Task__c projectTask : ProjectTaskTriggerHelper.ProjectTaskToValidateNextTask(ProjectTaskToNextValitionList, projectTaskIdsToValidateNextTask)){
            	Trigger.newMap.get(projectTask.Id).Completed__c.addError('Complete your task if your Next Text is Completed');   
         }	
     }
    
    List<Project_Task__c> projectTaskList = Trigger.new;
    if(Trigger.isAfter){
        List<Project__c> projectList = ProjectTaskTriggerHelper.afterUpdateProjectTask(projectTaskList);
        if(Constants.UpsertBreak){
                Constants.UpsertBreak= false;
                UPSERT projectList;
        }
    }
    if(Trigger.isBefore){
        ProjectTaskTriggerHelper.beforeUpdateProjectTaskToValidateDate(Trigger.new);
    }
}