/**
 * Created by tamarack on 1/7/20.
 */

@isTest
public with sharing class TC_CostOfFundTriggerHelperTest {

    @isTest
    public static void updateCOFInformationTest() {

        List<Opportunity> oppList = new List<Opportunity>();

        Opportunity opp1 = new Opportunity(
                Name = 'opp1 COFTriggerHelperTest', StageName = 'Test', CloseDate = System.today() + 90
        );
        opp1.Term__c = 110;
        opp1.COF_Date__c = System.today();
        opp1.COF__c = 2.0;
        oppList.add(opp1);

        Opportunity opp2 = new Opportunity(
                Name = 'opp2 COFTriggerHelperTest', StageName = 'Test', CloseDate = System.today() + 90
        );
        opp2.Term__c = 12;
        oppList.add(opp2);

        Opportunity opp3 = new Opportunity(
                Name = 'opp3 COFTriggerHelperTest', StageName = 'Test', CloseDate = System.today() + 90
        );
        opp3.Term__c = 1;
        opp3.COF__c = 3.79;
        oppList.add(opp3);

        insert oppList;

        List<Cost_of_Fund__c> cofList = new List<Cost_of_Fund__c>();
        Cost_of_Fund__c cof1 = new Cost_of_Fund__c(Date__c = System.today() - 10, X109_120__c = 2.3);
        cofList.add(cof1);

        Cost_of_Fund__c cof2 = new Cost_of_Fund__c(Date__c = System.today(), X12__c = 2.26);
        cofList.add(cof2);

        Test.startTest();
        insert cofList;
        Test.stopTest();

    }
}