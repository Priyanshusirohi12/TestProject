public with sharing class ContactRecordsController {
    public ContactRecordsController() {
        
    }
    @AuraEnabled (cacheable = true)
    public static List<Student__c> showContacts(){
        return [SELECT Id, Name, Last_Name__c, Email__c, Gender__c from Student__c];       
    }
}