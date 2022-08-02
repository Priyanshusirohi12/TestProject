/**
 * Created by Tamarack Consulting on 2019-08-14.
 */
@isTest
public with sharing class TC_RunRateCardCtrlTest {

    @isTest
    public static void test() {
        Opportunity opp = new Opportunity(Name='test',StageName='Credit',CloseDate=Date.Today(),Term__c=null);
        insert opp;
        TC_RunRateCardCtrl.runFlow(opp.Id);
    }
}