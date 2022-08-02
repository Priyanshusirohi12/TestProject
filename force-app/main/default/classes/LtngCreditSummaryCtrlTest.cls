/**
 * Created on 2019-03-01.
 */

@isTest
private class LtngCreditSummaryCtrlTest {

    @testSetup
    private static void createData () {
        Account a = new Account();
        a.RecordTypeId = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        a.Name = 'Vendor';
        insert a;

        Account b = new Account();
        b.RecordTypeId = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Borrower').getRecordTypeId();
        b.Name = 'Borrower';
        insert b;

        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = b.Id;
        opp.Amount = 10000;
        opp.StageName = 'Pipeline';
        opp.CloseDate = System.today();
        insert opp;

        Equipment__c eqip = new Equipment__c();
        eqip.Opportunity__c = opp.Id;
        eqip.Full_Equipment_Description__c = 'test';
        eqip.Vendor__c = a.Id;
        insert eqip;

        Contact con = new Contact ();
        con.AccountId = b.Id;
        con.LastName = 'test';
        insert con;

        Relationship__c rel = new Relationship__c ();
        rel.Person__c = con.Id;
        rel.Relationship_Type__c = 'Personal Guarantee';
        rel.Related_Opportunity__c = opp.Id;
        insert rel;

        if (Type.forName('TamarackPI__Paynet_Credit_History_Report__c') != null) {
            sObject report2 = Schema.getGlobalDescribe().get('TamarackPI__Paynet_Credit_History_Report__c').newSObject();
            report2.put('TamarackPI__Account__c', b.Id);
            insert report2;
        }

        if (Type.forName('tc_dnbdirect__DnB_Direct_Data__c') != null) {
            sObject report3 = Schema.getGlobalDescribe().get('tc_dnbdirect__DnB_Direct_Data__c').newSObject();
            report3.put('tc_dnbdirect__Account__c', b.Id);
            insert report3;
        }

        if (Type.forName('TC_Score__Scorecard__c') != null) {
            sObject scorecard1 = Schema.getGlobalDescribe().get('TC_Score__Scorecard__c').newSObject();
            scorecard1.put('TC_Score__Opportunity_Lookup__c', opp.Id);
            insert scorecard1;
        }

    }

    @isTest
    static void initDataTest () {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        LtngCreditSummaryCtrl.initData(opp.Id);
        Test.stopTest();
    }

    @isTest
    static void updateSettingTest() {

        Credit_Package__c settings = Credit_Package__c.getInstance();
        String settingJson = JSON.serialize(settings);

        Test.startTest();
        LtngCreditSummaryCtrl.updateSetting(settingJson);
        Test.stopTest();
    }
}