@IsTest
public with sharing class TC_OpportunityTriggerHelperTest {
    @IsTest
    static void testTriggers() {

        Account acc = new Account();
        acc.Name = 'test';

        insert acc;


        Opportunity opp = new Opportunity();
        opp.Name = 'test1';
        opp.CloseDate = Date.today();
        opp.StageName = 'test';
        opp.AccountId = acc.Id;
        opp.Originator_Email__c = 'test@test.com';

        insert opp;

    }
}