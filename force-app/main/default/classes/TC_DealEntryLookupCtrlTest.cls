/**
 * Created by szheng on 2019-09-06.
 */

@isTest
public with sharing class TC_DealEntryLookupCtrlTest {

    @testSetup
    private static void createData () {
        Account a = new Account ();
        a.Name = 'some test';
        insert a;

        Contact con = new Contact();
        con.LastName = 'test';
        con.FirstName = 'test';
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
    public static void testBehavior () {
        Test.startTest();
        TC_DealEntryLookupCtrl.search('Contact',
                'test',
                new List <String>{'Id != null'},
                new List <String> {'Account.Name'});
        TC_DealEntryLookupCtrl.getRecentlyViewed('Contact',
                new List <String>{'Id != null'},
                new List <String> {'Account.Name'});
        Test.stopTest();
    }

}