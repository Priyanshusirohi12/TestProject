public with sharing class ContactController {
    public ContactController() {
        
    }
    @AuraEnabled (cacheable = true)
    public static Contact getRecordById(Id id){
        return [Select Id, Name, Email, Phone, Fax, AccountId from Contact where Id =:id ];
    }
    @AuraEnabled 
    public static List<Account> getAccountList(){
        return [Select Id, Name, AccountNumber, Email__c, Phone From Account];
    } 
    
    @AuraEnabled (cacheable = true)
    public static List<Contact> getContactList(){
        return [Select Id, Name, Email, Phone, Fax, AccountId FROM Contact limit 5];
    }
    
}