public with sharing class HotalCustomerController {
    public HotalCustomerController() {
        
    }
    @AuraEnabled (cacheable = true)
    public static List<Hotal_Customer__c> showCustomer(){
        return [SELECT Id, First_Name__c, Last_Name__c, Gender__c, City__c, Email__c, Is_Married__c, Phone__c FROM Hotal_Customer__c];       
    }
    @AuraEnabled
    public static Hotal_Customer__c fatchRecord(Id id){
        return [ SELECT Id, First_Name__c, Last_Name__c, Gender__c, City__c, Email__c, Is_Married__c, Phone__c FROM Hotal_Customer__c where Id =: id];
    }
    @AuraEnabled
    public static Hotal_Customer__c  updateRecord(Hotal_Customer__c customer, String label){
        if(label.equals('Clone')){
            customer.Id = null;
        }
        Upsert customer;
        
        return customer;
    }
    @AuraEnabled
    public static Hotal_Customer__c deleteRecord(Hotal_Customer__c customer)
    {
        delete customer;
        return customer;
    } 
}