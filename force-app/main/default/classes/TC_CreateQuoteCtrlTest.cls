/**
 * Created on 3/31/18.
 */

@isTest
private class TC_CreateQuoteCtrlTest {

    @testSetup
    private static void createData () {
        Rate_Factor_Rule__c rfr = new Rate_Factor_Rule__c();
        rfr.Payment_Frequency__c = 'Monthly';
        rfr.Minimum_Price__c = 0.0;
        rfr.Maximum_Price__c = 100000000.0;
        rfr.Term__c = '48 Months';
        rfr.Credit_Rating__c = 'B';
        rfr.Active__c = true;
        rfr.Rate_Factor__c = 0.00001;


        insert rfr;


        Account a = new Account();
        a.Name = 'GUEST USER ACCOUNT';
        insert a;
    }

    @isTest
    static void testCalculateQuoteOptionsByRateTerm () {

        Test.startTest();
        TC_CreateQuoteCtrl.initQuoteOptionSelections();
        TC_CreateQuoteCtrl.calculateQuoteOptionsByRateTerm(new List <String> {
                '48'
        }, new Quote_Option__c (Payment_Frequency__c = 'Monthly', Interest_Rate__c = 2.0, Finance_Amount__c = 10000.00, Balloon_Amount__c = 1.0));

        Test.stopTest();
    }

    @isTest
    static void testCalculateQuoteOptionsByRateFactor () {

        Test.startTest();

        TC_CreateQuoteCtrl.calculateQuoteOptionsByRateFactor(new List <String> {
                '48'
        }, new Quote_Option__c (Payment_Frequency__c = 'Monthly', Interest_Rate__c = 2.0, Finance_Amount__c = 10000.00, Balloon_Amount__c = 1.0, Rate_Factor__c = 0.1));

        Test.stopTest();
    }

    @isTest
    static void testCalculateQuoteOptionsByCreditRating () {

        Test.startTest();

        TC_CreateQuoteCtrl.calculateQuoteOptionsByCreditRating(new Quote_Option__c (Payment_Frequency__c = 'Monthly', Interest_Rate__c = 2.0, Finance_Amount__c = 10000.00, Balloon_Amount__c = 1.0, Rate_Factor__c = 0.1), new List <String> {
                '48 Months'
        }, 'B');

        Test.stopTest();
    }


    @isTest
    static void testCreateApplication () {

        List <Quote_Option__c> qoList = new List <Quote_Option__c> ();

        Quote_Option__c qo = new Quote_Option__c();

        qo.Finance_Amount__c = 100000;
        qo.Term_Months__c = 24.0;
        qo.Payment_Frequency__c = 'Monthly';
        qo.Payment_Amount__c = 12.00;

        qoList.add(qo);
        Test.startTest();
        TC_CreateQuoteCtrl.createLoanApplication(JSON.serialize(qoList));
        Test.stopTest();


    }
}