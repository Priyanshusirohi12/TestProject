/**
 * Created 23.01.2020.
 */

public with sharing class GanttData {
    @RemoteAction
    @AuraEnabled
    public static List<Sprint__c> getSprintList(Id projectId, List<String> statusFilter) {  
        
        String query = 'SELECT Id, Name, Start_Date__c, End_Date__c, Duration__c, Status__c, Gantt_Project__c, Gantt_Project__r.Name,  (SELECT Id, Who.Name, Subject, Start_Date__c, Progress__c, Status, Owner.Name, Sprint__c, Sprint__r.Name, Priority, Duration__c, ActivityDate FROM Activities__r ) FROM Sprint__c WHERE Gantt_Project__c =: projectId ORDER BY CreatedDate';
        
        if(statusFilter.size() > 0 ){
            query = 'SELECT Id, Name, Start_Date__c, End_Date__c, Duration__c, Status__c, Gantt_Project__c, Gantt_Project__r.Name, (SELECT Id, Who.Name, Subject, Start_Date__c, Progress__c, Status, Owner.Name, Sprint__c, Sprint__r.Name, Priority, Duration__c, ActivityDate FROM Activities__r WHERE Status in: statusFilter) FROM Sprint__c WHERE Gantt_Project__c =: projectId ORDER BY CreatedDate';
        }
        List<Sprint__c> sprintList = new List<Sprint__c>();
        /*sprintList =[SELECT Id, Name, Start_Date__c, End_Date__c, Duration__c, Status__c,
                    (SELECT Id, Who.Name, Subject, Start_Date__c, Progress__c, Status, Owner.Name, Sprint__c, 
                    Sprint__r.Name, Priority,  Duration__c, ActivityDate FROM Activities__r WHERE Status in: statusFilter )  
                    FROM Sprint__c
                    WHERE Gantt_Project__c =: projectId];*/
        sprintList = database.query(query);
        
        List<GanttLink__c> Links = new List<GanttLink__c>();
        Links = [SELECT Id, Type__c, Source__c, Target__c 
                 FROM GanttLink__c];
        //Map<String, Object> result = new Map<String, Object>{'sprints' => sprintList, 'links' => Links };
        return sprintList;
   }
    @AuraEnabled
    public static Map<String, Object> compareTaskDates(Id sprintId){
        Date minStartDate = null;
        Date maxEndDate = null;
        List<Task> taskList = [SELECT Start_Date__c, ActivityDate FROM Task WHERE Sprint__c =: sprintId];
        if(taskList.size() > 0){
            for(Task task : taskList){
                if(minStartDate == null || ( minStartDate != null && task.Start_Date__c < minStartDate)){
                    minStartDate = task.Start_Date__c;
                }
                if(maxEndDate == null || ( maxEndDate != null && task.ActivityDate > maxEndDate)){
                    maxEndDate = task.ActivityDate;
                }
            }
        
        Map<String, Object> sprintDatesMap = new Map<String, Object>{'minStartDate' => minStartDate, 'maxEndDate' => maxEndDate};
        return sprintDatesMap;  
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static Map<String, Object> getStatusPickListValues(){
        Map <String,List<String>> fillMapOfSprintRecords = new Map<String,List<String>>();
        SObject obj = new Sprint__c();
        String statusField = 'Status__c';
        List<String> pickListData = new List<String>();
        Schema.sObjectType objType = obj.getSObjectType();
        System.debug(objType+' objType');
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get(statusField).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
        	pickListData.add(a.getValue());
        }
        //System.debug('pickListData '+pickListData);
        //fillMapOfSprintRecords.put('picklistValues',pickListData);
        List<Gantt_Project__c> projectList = [SELECT Id, Name, Start_Date__c, End_Date__c FROM Gantt_Project__c Order By Name];
       	Map<String, Object> result = new Map<String, Object>{'picklistValues' => pickListData, 'projectList' => projectList };
       	//fillMapOfSprintRecords.put('projectList',projectList);
        	
        return result; 
    }
    
   @AuraEnabled
   public static Map<String, List<String>> getAllPicklistValues(){
       try {
       	Map<String,List<String>> DataMap = new Map<String, List<String>>();
        SObject obj = new Task();
        List<String> fldList = new List<String>{'Status', 'Priority'};
        Integer i = 0;
        for(String fld : fldList){
        	List<String> pickListData = new List<String>();
           	Schema.sObjectType objType = obj.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
            list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : values)
            { 
               pickListData.add(a.getValue());
            }
            DataMap.put('data'+i, pickListData);
            i++;
       	}
            List<String> pickListData = new List<String>();
            for(User user : [SELECT Id, Name FROM User Order by Name]){
                String value = user.Name;
                value = value +'& '+user.Id;
                pickListData.add(value);
            }
            DataMap.put('data'+i, pickListData);
           	List<String> taskIdList = new List<String>();
            for(Task task : [SELECT Id FROM Task]){
            	taskIdList.add(task.Id);     
            }
           	DataMap.put('data3',taskIdList);
           	List<String> sprintList = new List<String>();
            for(Sprint__c sprint : [SELECT Id, Name FROM Sprint__c Order By Name]){
                String value = sprint.Name;
                value = value +'& '+sprint.Id;
                sprintList.add(value);
            }
           DataMap.put('data4',sprintList);
    	    return DataMap;
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
 		}
	}
   @AuraEnabled
   public static Task upsertTask(Task task){
       try {
           if(task.Id == null){
               INSERT task;
               return task;
           }
           else if(task.Id != null){
               UPDATE task;
               System.debug('task '+task);
               return task;
           }else{
               return null;
           }
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }
   @AuraEnabled
    public static Task deleteTaskRecord(Id id){
    	Task task = new Task(Id = id);
        DELETE task;
        return task	 ;     
    }
}