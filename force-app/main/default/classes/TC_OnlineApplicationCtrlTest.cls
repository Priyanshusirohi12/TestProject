/**
 * Created on 2019-01-12.
 */

@isTest
private class TC_OnlineApplicationCtrlTest {

    @testSetup
    private static void createData () {

        Account partnerAccount = TestUtility.createAccount('Partner Account');
        //partnerAccount.RecordType = new RecordType(Name = 'LK EF Lender Account');
        insert partnerAccount;

        Account vendorAccount = TestUtility.createAccount('Vendor Account');
        vendorAccount.RecordType = new RecordType(Name = 'Vendor');
        insert vendorAccount;

        Application_Program__c applicationProgram = new Application_Program__c(Vendor__c = vendorAccount.Id);
        insert applicationProgram;

        Origination_Setting__c originationSetting = new Origination_Setting__c(Own_Company_Account_Id__c = partnerAccount.Id);
        insert originationSetting;

        Lead lead = new Lead(LastName='Lead Last Name', Company='Lead Company');
        insert lead;


    }

    @isTest
    static void submitFollowUp(){
        TC_OnlineApplicationCtrl oacl = new TC_OnlineApplicationCtrl();
        Test.startTest();
        try{
            TC_OnlineApplicationCtrl.submitFollowUp(JSON.serialize(oacl));
        }catch(Exception e){}

        Test.stopTest();
    }
    @isTest
    static void submitCommercialApplication(){
        TC_OnlineApplicationCtrl oacl = new TC_OnlineApplicationCtrl();
        Test.startTest();
        try{
            TC_OnlineApplicationCtrl.submitCommercialApplication(JSON.serialize(oacl));
        }catch(Exception e){}

        Test.stopTest();
    }
    @isTest
    static void doApplicationInitTest() {

        //insert queue
        Group g1 = new Group(Name='ABC_Lender_Queue', type='Queue');
        insert g1;
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');
        insert q1;


        List<Account> accountList = new List<Account>([SELECT Id, RecordType.Name FROM Account]);
        String vendorId;
        for (Account acc : accountList) {
            if (acc.RecordType.Name == 'Vendor') vendorId = acc.Id;
        }
        Test.startTest();
        String urlParameters = '{"Equipment_1_Address__c":"1234","createddate":"12/12/2001","lasttransferdate":"12/12/2001","authorized_credit_check__c":"true","annualrevenue":"123","account_number_2__c":"test","Guarantor_Annual_Income_2__c":1000,"Equipment_Price_2__c":100,"Custom_Field_1_Label__c":"8"}';
        TC_OnlineApplicationCtrl.doApplicationInit('', vendorId, null, urlParameters);
        Test.stopTest();
    }

    @isTest
    static void doApplicationInitTest2() {

        String urlParameters = '{"Guarantor_Annual_Income_2__c":1000,"Equipment_Price_2__c":100,"Custom_Field_1_Label__c":"8"}';
        TC_OnlineApplicationCtrl wrapper = new TC_OnlineApplicationCtrl();
        wrapper.leadId = 'xxx';
        try{
            Test.startTest();
            TC_OnlineApplicationInitCtrl.getLeadInformation(urlParameters, wrapper);
            Test.stopTest();
        }catch(Exception e){}
    }

    /*@isTest
    static void testNewLead () {
        Test.startTest();
        TC_OnlineApplicationCtrl.createLead(
            new Lead (Company = '123 Company', LastName = 'Tester'),
            new List <Contact> {new Contact (LastName = 'Contact')},
            new List <Equipment__c> {new Equipment__c (Name = 'test')},
            UserInfo.getUserId(),
            [SELECT  Id FROM Account WHERE AccountNumber = 'V123123' LIMIT 1].Id,
            FIELDS_JSON, new List <String> {'0695C0000000ou1'}
        );

        TC_OnlineApplicationCtrl.getPartnerInformation('A123123','1234');
        Test.stopTest();
    }

    @isTest
    static void testCreateLeadException () {
        Test.startTest();
        try {
            TC_OnlineApplicationCtrl.createLead(new Lead (Company = '123 Company', LastName = 'Tester'),
                new List <Contact> ()
                , new List <Equipment__c> (),
                UserInfo.getUserId(),
                [SELECT  Id FROM Account WHERE AccountNumber = 'V123123' LIMIT 1].Id,
                FIELDS_JSON, new List <String> {
                '0695C0000000ou1'
            });

        } catch (Exception e) {
            System.assert(true);
        }

        Test.stopTest();
    }

    @isTest
    static void testPartnerInfoException () {
        Test.startTest();


        try {
            TC_OnlineApplicationCtrl.getPartnerInformation('null',null);
        } catch (Exception e) {
            System.assert(true);
        }

        Test.stopTest();
    }

    @isTest
    static void testDelete () {
        Test.startTest();
        TC_OnlineApplicationCtrl.deleteDocument('0695C0000000ou1');
        Test.stopTest();
    }

    @isTest
    static void testCreateOwnerLead () {
        Test.startTest();
        TC_OnlineApplicationCtrl.createOwnerOperatorLead(
            new Lead (Company = '123 Company', LastName = 'Tester'),
            UserInfo.getUserId(),
            FIELDS_JSON, new List <String> (),
            [SELECT  Id FROM Account WHERE AccountNumber = 'V123123' LIMIT 1].Id);

        Test.stopTest();
    }*/
}