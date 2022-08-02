/**
 * Created on 4/1/18.
 */

@isTest
private class TC_LookupInputCtrlTest {

    @testSetup
    private static void createData () {
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
    static void testBehavior () {
        Test.startTest();
        TC_LookupInputCtrl.search('Contact', 'test', new List <String>{'Id != null'},new List <String> {'Account.Name'});
        TC_LookupInputCtrl.getRecentlyViewed('Contact', new List <String>{'Id != null'},new List <String> {'Account.Name'});
        Test.stopTest();
    }
}