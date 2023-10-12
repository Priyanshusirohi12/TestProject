public class InsertGanttProductAndSprint{
    
    
	@AuraEnabled
    public static List<Gantt_Project__c> getGanttProject(String value){
        	return [SELECT Id, Name, Start_Date__c, End_Date__c, Status__c, Cost__c, Client__c, Client__r.Name  FROM Gantt_Project__c WHERE Name LIKE: + value + '%' Order by Name];
   }
    
    /*@AuraEnabled
    public static List<Gantt_Project__c> getGanttProjects(){
        System.debug('gf');
        return [SELECT Id, Name FROM Gantt_Project__c];
    }*/
    
    @AuraEnabled
    public static Map<String,List<String>> getStatusPickListValues(){
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
        System.debug('pickListData '+pickListData);
        fillMapOfSprintRecords.put('picklistValues',pickListData);
        List<String> projectList = new List<String>();
        List<String> projectDateList = new List<String>();
            for(Gantt_Project__c ganttProject : [SELECT Id, Name, Start_Date__c, End_Date__c FROM Gantt_Project__c Order by Name]){
                String projectrecords = ganttProject.Name;
                projectrecords = projectrecords +'& '+ganttProject.Id;
                projectList.add(projectrecords);
                String ganttDate = ganttProject.Start_Date__c.format();
                ganttDate += ' /' + ganttProject.End_Date__c.format();
				//projectDateList.add(ganttProject.Start_Date__c.format());
                projectDateList.add(ganttDate);
            }
        	fillMApOfSprintRecords.put('projectDateList',projectDateList);
        	fillMapOfSprintRecords.put('projectList',projectList);
        	
        return fillMapOfSprintRecords; 
    }
    @AuraEnabled
    public static Map<String, Object> compareSprintDates(Id projectId){
       List<AggregateResult> aggregateResults = [SELECT MIN(Start_Date__c) MIN_Start_Date__c, MAX(End_Date__c) MAX_End_Date__c, Gantt_Project__c from Sprint__c group by Gantt_Project__c HAVING Gantt_Project__c =: projectId];
        if(aggregateResults.size() > 0){
            /*String sprintMaxEndDate = String.valueOf(aggregateResults[0].get('MAX_End_Date__c'));
            String sprintMinStartDate = String.valueOf(aggregateResults[0].get('MIN_Start_Date__c'));
            System.debug('sprintMinStartDate '+sprintMinStartDate);
            System.debug('sprintMaxEndDate '+sprintMaxEndDate);*/
            Map<String, Object> sprintDatesMap = new Map<String, Object>{'sprintMinStartDate' => aggregateResults[0].get('MIN_Start_Date__c'), 'sprintMaxEndDate' => aggregateResults[0].get('MAX_End_Date__c')};
            return sprintDatesMap;    
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static Gantt_Project__c insertProject(Gantt_Project__c project){
        system.debug('project '+project);
        	UPSERT project;
            System.debug('project '+project);
            return project; 
    }
    @AuraEnabled
    public static Map<String,List<String>> getGanttProjectTypePickListValues(){
       Map<String,List<String>> dataMap = new Map<String,List<String>>();
       SObject obj = new Gantt_Project__c();
        String status = 'Status__c';
        List<String> pickListData = new List<String>();
        Schema.sObjectType objType = obj.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get(status).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
        	pickListData.add(a.getValue());
        }
        dataMap.put('statusPickList', pickListData);
        List<String> contactList = new List<String>();
            for(Contact contact : [SELECT Id, Name FROM Contact Order by Name]){
                String contactRecord = contact.Name;
                contactRecord = contactRecord +'& '+contact.Id;
                contactList.add(contactRecord);
            }
        	dataMap.put('contactList',contactList);
        System.debug('pickListData '+pickListData);
 		return dataMap;
    }
    @AuraEnabled
    public static List<String> getTaskStatusPickList(){
        SObject obj = new Task();
        String status = 'Status';
        List<String> pickListData = new List<String>();
        Schema.sObjectType objType = obj.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get(status).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
        	pickListData.add(a.getValue());
        }
        System.debug('pickListData '+pickListData);
 		return pickListData;
    } 
}