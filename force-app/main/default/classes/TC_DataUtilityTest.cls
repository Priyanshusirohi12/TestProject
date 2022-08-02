@IsTest
public with sharing class TC_DataUtilityTest {

    @TestSetup
    public static void setUp(){
        Account a = new Account();
        a.Name = 'test';
        insert a;

        Opportunity op = new Opportunity();
        op.Name = 'test';
        op.Account = a;
        op.AccountId = a.Id;
        op.CloseDate = Date.today().addYears(1);
        op.StageName = 'test';
        insert op;

        Contact c = new Contact();
        c.Account = a;
        c.AccountId = a.Id;
        c.FirstName = 'test';
        c.LastName = 'test';
        insert c;

        Like_Term_Swap__c likeTermSwap = new Like_Term_Swap__c();
        likeTermSwap.Name = 'test';
        insert likeTermSwap;
    }

    @IsTest
    public static void createSelectAllQueryStringTest(){
        Test.startTest();
        String ret = TC_DataUtility.createSelectAllQueryString('Account', ' ', null);
        String ret2 = TC_DataUtility.createSelectAllQueryString('Account', 'Name = \'test\' ', null);
        Test.stopTest();
        System.assert(ret <> null);
        System.assert(ret2 <> null);
    }

    @IsTest
    public static void getAllFieldsOnAccountByRecordIdTest(){
        Account a = [SELECT Id FROM Account LIMIT 1].get(0);
        Test.startTest();
        Account aa = TC_DataUtility.getAllFieldsOnAccountByRecordId(a.Id);
        Test.stopTest();
        System.assert(aa <> null);
    }

    @IsTest
    public static void getAllFieldsOnOpportunityByRecordIdTest(){
        Opportunity op = [SELECT Id FROM Opportunity LIMIT 1].get(0);
        Test.startTest();
        Opportunity opp = TC_DataUtility.getAllFieldsOnOpportunityByRecordId(op.Id);
        Test.stopTest();
        System.assert(opp <> null);
    }

    @IsTest
    public static void getAllFieldsOnContactByRecordIdTest(){
        Contact c = [SELECT Id FROM Contact LIMIT 1].get(0);
        Test.startTest();
        Contact cc = TC_DataUtility.getAllFieldsOnContactByRecordId(c.Id);
        Test.stopTest();
        System.assert(cc <> null);

    }

    @IsTest
    public static void getAllFieldsOnLikeTermSwapLimitMostRecentTest(){
        Test.startTest();
        Like_Term_Swap__c likeTermSwap = TC_DataUtility.getAllFieldsOnLikeTermSwapLimitMostRecent();
        Test.stopTest();
        System.assert(likeTermSwap <> null);
    }
}