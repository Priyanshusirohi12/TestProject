/*
	Created by : Syed mehdi
	Created Date : Feb-03-2023

*/
@isTest
public class ProgramTriggerTest {
    @TestSetup
    public static void createTestData(){
    	Account account = new account(Name = 'Test Account');
    	insert account;
    }
    @isTest
    private static void testProgramTrigger(){
        Account account = [Select Id, Name From Account Limit 1];
        Id recordTypeId = Schema.SObjectType.Program__c.getRecordTypeInfosByName().get('Test Record Type').getRecordTypeId();
    	List<Program__c> programList = new List<Program__c>();
        
        programList.add(new Program__c(Name = 'Test Program', RecordTypeId = recordTypeId,  Account__c = account.Id, Brand_VOC__c ='Neutral', Pay_Rate__c = 'Flat rate', Pay_Rate_Amount__c = 5000));	
        insert programList;
        Assert.areEqual(programList[0].Id != null, true);
        
        programList[0].Brand_VOC__c = 'Positive';
        ProgramTriggerHelper.counter = false;
        update programList;
        Assert.areEqual( 'Positive',programList[0].Brand_VOC__c);
        ProgramTriggerHelper.counter = false;
        delete programList;
    }
}