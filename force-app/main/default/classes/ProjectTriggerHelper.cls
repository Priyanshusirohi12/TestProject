public class ProjectTriggerHelper {
    public static void showErrorOnProjectInsert(List<Project__c> projectList){
        for(Project__c project : projectList){
            if(project.Status__c != null){
                project.Status__c.addError('You can not choose this field from here');
            }
        } 
    }
    public static void showErrorOnProjectUpdate(List<Project__c> projectList, Map<Id, Project__c> projectMap, Map<Id, Project__c> projectOldMap){
        for(Project__c project : projectList){
        	if(projectMap.get(project.Id).Status__c != projectOldMap.get(project.Id).Status__c){
       			projectMap.get(project.Id).Status__c.addError('You can not change this field from here');
            }
    	}
    }
    public static void toCreateProjectTask(List<Project__c> projectList){
        List<Project_Task__c> probjectTaskListToInsert = new List<Project_Task__c>();
        //List<Id> ProjctTaskIdList = new List<Id>();
        
        for(Project__c project : projectList){
            probjectTaskListToInsert.add(new Project_Task__c(Type__c='New Task', Project__c =Project.Id));
            probjectTaskListToInsert.add(new Project_Task__c(Type__c='Planning Phase', Project__c =Project.Id));
            probjectTaskListToInsert.add(new Project_Task__c(Type__c='Construction Work', Project__c =Project.Id));
            probjectTaskListToInsert.add(new Project_Task__c(Type__c='Completion Step', Project__c =Project.Id));
            probjectTaskListToInsert.add(new Project_Task__c(Type__c='Contract End', Project__c =Project.Id));
        }
       	INSERT probjectTaskListToInsert;
        for(Integer index=1; index < probjectTaskListToInsert.size(); index++){
            if(probjectTaskListToInsert.get(index).Type__c != 'New Task'){
                probjectTaskListToInsert.get(index).Previous_Task__c = probjectTaskListToInsert.get(index-1).Id;
            }
        }
    	if(probjectTaskListToInsert.size() > 0){
        	upsert probjectTaskListToInsert;
        }
    }
}