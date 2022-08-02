/**
 * Created by tamarack on 1/7/20.
 */

@isTest
public with sharing class TC_LikeTermSwapTriggerHelperTest {

    @isTest
    private static void updateLTSInformationTest() {

        List<Opportunity> oppList = new List<Opportunity>();

        Opportunity opp1 = new Opportunity(
                Name = 'opp1 LTSTriggerHelperTest', StageName = 'Test', CloseDate = System.today() + 90
        );
        opp1.Term__c = 110;
        oppList.add(opp1);

        Opportunity opp2 = new Opportunity(
                Name = 'opp2 LTSTriggerHelperTest', StageName = 'Test', CloseDate = System.today() + 90
        );
        opp2.Term__c = 12;
        oppList.add(opp2);

        Opportunity opp3 = new Opportunity(
                Name = 'opp3 LTSTriggerHelperTest', StageName = 'Test', CloseDate = System.today() + 90
        );
        opp3.Term__c = 1;
        opp3.LTS__c = 1.0;
        oppList.add(opp3);

        insert oppList;

        Like_Term_Swap__c lts = new Like_Term_Swap__c(Date__c = System.today(), x110__c = 1.97, x12__c = 1.8);

        Test.startTest();
        insert lts;
        Test.stopTest();

    }

}