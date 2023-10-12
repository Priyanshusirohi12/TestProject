public class ProjectTaskTriggerHelper {
	
    Static Map<Id,Project_Task__c> allProjectTask;
   		
     public static List<Project_Task__c> ProjectTaskToValidatePreviousTask(Set<Id> projectTaskIdsSet) {        
         List<Project_Task__c> projectTaskListToValidatePreviousTask = [SELECT Id, Previous_Task__c, Type__c
                                                                        FROM Project_Task__c
                                                                        WHERE Id in : projectTaskIdsSet
                                                                        AND Previous_Task__c NOT in : projectTaskIdsSet
                                                                       	AND Type__c != 'New Task'
                                                                       	AND Previous_Task__r.Completed__c = false];
         return projectTaskListToValidatePreviousTask;   
    }
    
    public static List<Project_Task__c> ProjectTaskToValidateNextTask(List <Project_Task__c> ProjectTaskToNextValitionList, Set<Id> projectIdsSet){
        List<Project_Task__c> projectTaskList = new List<Project_Task__c>();
        Map<Id, Project_Task__c> mapOfIdToProjectTask = new Map<Id, Project_Task__c>
             											([SELECT Id, Completion__c, Type__c, Completed__c, Previous_Task__c,
                                                        Project__c, (SELECT Id, Name, Completed__c, Type__c
                                                        FROM Project_Tasks__r)             
                                                        FROM Project_Task__c 
                                                        WHERE Project__c =: projectIdsSet]);
        for(Project_Task__c projectTaskObject : ProjectTaskToNextValitionList) {
            Project_Task__c nextProjectTask = new Project_Task__c();
            if(mapOfIdToProjectTask.get(projectTaskObject.Id).Project_Tasks__r.size() != 0){
                System.debug('hi coming first if');
            	nextProjectTask = mapOfIdToProjectTask.get(projectTaskObject.Id).Project_Tasks__r;
            }
         	if(!projectTaskObject.Completed__c && projectTaskObject.Previous_Task__c == NULL && nextProjectTask.Completed__c){
                System.debug('hi coming second if');
                //projectTaskObject.Completed__c.addError('Complete your first task if next task is complete');
                projectTaskList.add(projectTaskObject);
            }else if(nextProjectTask.Completed__c && !projectTaskObject.Completed__c){
                System.debug('hi coming third if');
                //projectTaskObject.Completed__c.addError('Complete your previous task if next task is complete');
            	projectTaskList.add(projectTaskObject);
            }
        }
        return projectTaskList;
    } 
    public static List<Project__c> afterUpdateProjectTask(List<Project_Task__c> ProjectTaskList){
      Map<Id,Project_Task__c> projectTaskMap = new Map<Id,Project_Task__c>();
        for(Project_Task__c projectTask : ProjectTaskList){
            projectTaskMap.put(projectTask.Project__c,projectTask);
        }
        List<Project__c> projectList = [SELECT Id, Name, Status__c FROM Project__c WHERE Id =: projectTaskMap.keySet()];
        for(Project__c project : projectList){
           Project_task__c projectTask = projectTaskMap.get(project.Id);
            if(projectTask.Completed__c && projectTask.Type__c=='New Task'){
                project.Status__c = 'New';
            }
            else if(projectTask.Completed__c && projectTask.Type__c=='Planning Phase'){
                project.Status__c = 'Planning';
            }
            else if(projectTask.Completed__c && projectTask.Type__c=='Construction Work'){
                project.Status__c = 'Construction';
            }
            else if(projectTask.Completed__c && projectTask.Type__c=='Completion Step'){
                project.Status__c = 'Deployment';
            }
            else if(projectTask.Completed__c && projectTask.Type__c=='Contract End'){
                project.Status__c = 'Signoff';
            }  
    	}
        return projectList;
	}
    
    public static void beforeUpdateProjectTaskToValidateDate(List<Project_Task__c> projectTaskList){
        for(Project_Task__c projectTask : projectTaskList){
            if(projectTask.Completion__c == null && projectTask.Completed__c){
                projectTask.Completion__c.addError('You have to fill the date before complete');
            }
            if(projectTask.Completion__c != null && !projectTask.Completed__c){
                projectTask.Completed__c.addError('Make complete checkbox checked if date is filled');
            }
        }
    }
}