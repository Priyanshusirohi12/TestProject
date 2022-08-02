@IsTest
public with sharing class TC_GetPicklistOptionsCtrlTest {

    @TestSetup
    public static void setUp(){
        Account a = new Account();
        a.Name = 'test';
        a.BillingCountry = 'United States';
        insert a;

        Contact c = new Contact();
        c.LastName = 'test';
        c.FirstName = 'test';
        c.Account = a;
        c.AccountId = a.Id;
        c.MailingCountryCode = 'CA';
        insert c;
    }

    @IsTest
    public static void getSelectOptionsTest(){
        Account a = [SELECT Id FROM Account LIMIT 1].get(0);
        Contact c = [SELECT Id FROM Contact LIMIT 1].get(0);
        Test.startTest();
        List<String> options = TC_GetPicklistOptionsCtrl.getSelectOptions(a, 'AccountSource');
        List<String> options2 = TC_GetPicklistOptionsCtrl.getSelectOptions(c, 'MailingStateCode');
        Test.stopTest();
        System.assert(options<>null);
        System.assert(options2<>null);
    }
    @IsTest
    public static void setPickListValTest(){
        Contact c = [SELECT Id FROM Contact LIMIT 1].get(0);
        Test.startTest();
        sObject obj = TC_GetPicklistOptionsCtrl.setPickListVal(c, 'MailingStateCode', 'CA');
        Test.stopTest();
        System.assert(obj<>null);
    }




}