@isTest
public with sharing class TC_RecordLookupCtrlTest {

    @testSetup
    private static void createData () {
        Account a = new Account ();
        a.Name = 'some test';
        a.BillingStreet = 'test';
        a.BillingCity = 'test';
        a.BillingState = 'Minnesota';
        a.BillingPostalCode = '12345';
        insert a;

        Contact con = new Contact();
        con.LastName = 'test';
        con.FirstName = 'test';
        con.AccountId = a.Id;
        con.MailingStreet = 'test';
        con.MailingCity = 'test';
        con.MailingState = 'Minnesota';
        con.MailingPostalCode = '54133';
        insert con;

        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.StageName = 'Not Submitted';
        opp.CloseDate = System.today()+1;
        opp.AccountId = a.Id;

        insert opp;
    }

    @isTest
    public static void testBehavior () {
        Test.startTest();
        TC_RecordLookupCtrl.search('Contact',
                'test',
                new List <String>{'Id != null'},
                new List <String> {'Account.Name'});
        TC_RecordLookupCtrl.getRecentlyViewed('Contact',
                new List <String>{'Id != null'},
                new List <String> {'Account.Name'});
        Test.stopTest();
    }

}