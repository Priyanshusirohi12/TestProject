/**
 * Created 23.01.2020.
 */

public with sharing class GanttData {

    @RemoteAction
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getTasks() {
        
        // fetching the Records via SOQL
        List<Task> Tasks = new List<Task>();
        
        Tasks = [SELECT Id, Who.Name, Subject, Start_Date__c, Status, Owner.Name, Priority,  Duration__c, ActivityDate FROM Task];
        System.debug(Tasks);
        List<GanttLink__c> Links = new List<GanttLink__c>();
        Links = [SELECT Id, Type__c, Source__c, Target__c FROM GanttLink__c];

        Map<String, Object> result = new Map<String, Object>{'tasks' => Tasks, 'links' => Links };
        return result;
   }
   @AuraEnabled
   public static Map<String, List<String>> getAllPicklistValues(){
       try {
        Map<String,List<String>> carDataMap = new Map<String, List<String>>();
        SObject obj = new Task();
        List<String> fldList = new List<String>{'Status', 'Priority'};
        Integer i = 0;
        for(String fld : fldList){
               List<String> pickListData = new List<String>();
           Schema.sObjectType objType = obj.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
            list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
            System.debug('pick list values '+values);
            for (Schema.PicklistEntry a : values)
            { 
               pickListData.add(a.getValue());
            }
            carDataMap.put('data'+i, pickListData);
            i++;
       }
            List<String> pickListData = new List<String>();
            for(User user : [Select Id, Name FROM User]){
                String value = user.Name;
                value = value +'& '+user.Id;
                pickListData.add(value);
            }
               carDataMap.put('data'+i, pickListData);
            System.debug(carDataMap);
               return carDataMap;
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }
   @AuraEnabled
   public static Id insertTask(Task task){
       try {
           insert task;
           return task.Id;
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }
}