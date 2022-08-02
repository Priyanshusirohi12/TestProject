/**
 * Created on 3/31/18.
 */

@isTest
private class TC_LoanApplicationCtrlTest {

    @testSetup
    static void createData () {
        Account a = new Account ();
        a.Name = 'some test';
        insert a;

        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = a.Id;
        insert con;

        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.StageName = 'Pipeline';
        opp.CloseDate = System.today()+1;
        opp.AccountId = a.Id;

        insert opp;
    }


    @isTest
    static void testNoApp () {

        Test.startTest();

        TC_LoanApplicationCtrl.getApplicationById(null);

        Test.stopTest();

    }

    @isTest
    static void testWithAppId () {

        Test.startTest();

        TC_LoanApplicationCtrl.getApplicationById([SELECT Id FROM Opportunity LIMIT 1].Id);
        TC_LoanApplicationCtrl.getCompanyRecordById ([SELECT Id FROM Account LIMIT 1].Id, false);
        TC_LoanApplicationCtrl.getFilesByParentId ([SELECT Id FROM Account LIMIT 1].Id);
        Test.stopTest();

    }

    @isTest
    static void testSave () {

        Test.startTest();

        TC_LoanApplicationCtrl.saveDeal('{"Id":"'+ [SELECT Id FROM Opportunity LIMIT 1].Id +'","Name":"test", "AccountId": "' + [SELECT Id FROM Account LIMIT 1].Id + '"}');
        TC_LoanApplicationCtrl.saveCompany ('{"Id":"'+ [SELECT Id FROM Account LIMIT 1].Id +'","Name":"test"}');
        TC_LoanApplicationCtrl.saveGuarantors ([SELECT Id, AccountId, LastName FROM Contact]);
        Test.stopTest();

    }

    @isTest
    static void testSaveEquipment () {

        Test.startTest();

        TC_LoanApplicationCtrl.saveEquipment(new List <Equipment__c> {new Equipment__c()},'{"Id":"'+ [SELECT Id FROM Opportunity LIMIT 1].Id +'","Name":"test", "AccountId": "' + [SELECT Id FROM Account LIMIT 1].Id + '"}');

        Test.stopTest();

    }


    @isTest
    static void testSubmitApp () {

        List<Quote_Setting__mdt> quoteSetting = [
                SELECT Id
                        ,Credit_Rating_Config__c
                        ,Term_Config__c
                        ,Finance_Type__c
                        ,Payment_Frequency__c
                        ,Account_Name_for_Guest_User__c
                        ,Opp_Stage_Name_on_Create__c
                FROM Quote_Setting__mdt
                LIMIT 1
        ];

        Account a = new Account();
        a.Name = quoteSetting[0].Account_Name_for_Guest_User__c;
        a.RecordTypeId = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Broker').getRecordTypeId();
        insert a;

        Contact con = new Contact ();
        con.LastName = 'test_guest';
        con.AccountId = a.Id;
        insert con;

        Account company = [SELECT Id, Name FROM Account WHERE Id != :a.Id LIMIT 1];
        String companyString = JSON.serialize(company);

        Opportunity opp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        String dealString = JSON.serialize(opp);

        String guarantorsString = JSON.serialize([SELECT Id, Name, AccountId FROM Contact WHERE AccountId = :company.Id]);

        Equipment__c e = new Equipment__c();
        e.Opportunity__c = opp.Id;
        insert e;

        Test.startTest();

        TC_LoanApplicationCtrl.getDependentPicklists();

        TC_LoanApplicationCtrl.setIsMasterLine(opp.Id);
        TC_LoanApplicationCtrl.getMasterLine (opp.Id);
        TC_LoanApplicationCtrl.selectCompany(company.Id);
        TC_LoanApplicationCtrl.selectGuarantor(con.Id);

        TC_LoanApplicationCtrl.submitApplication(companyString, guarantorsString,  [SELECT Id, Name FROM Equipment__c], dealString);

        Test.stopTest();

    }
}