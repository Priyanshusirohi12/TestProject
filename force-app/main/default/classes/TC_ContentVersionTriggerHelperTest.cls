@IsTest
public with sharing class TC_ContentVersionTriggerHelperTest {
    @TestSetup
    public static void setUp(){
        Account a = new Account();
        a.Name = 'test';
        insert a;
        Opportunity op = new Opportunity();
        op.Account = a;
        op.AccountId = a.Id;
        op.Name = 'test';
        op.CloseDate = Date.today().addYears(1);
        op.StageName = 'test';
        insert op;

        ContentVersion content=new ContentVersion();
        content.Title='Testing the File';
        content.PathOnClient='TESTfile.pdf';
        content.VersionData=Blob.valueOf('Test Content');
        insert content;
        insert new ContentDocumentLink (ContentDocumentId = [SELECT Id FROM ContentDocument LIMIT 1].Id, LinkedEntityId = [SELECT Id, Name FROM Opportunity where Name = 'test'].Id, ShareType = 'I');

    }


    @IsTest
    public static void linkOnlineAppPDFTest(){
        Test.startTest();


        Test.stopTest();

    }

}