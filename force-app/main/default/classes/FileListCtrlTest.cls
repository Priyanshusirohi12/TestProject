@IsTest
public with sharing class FileListCtrlTest {

    @TestSetup
    public static void setUP(){
        Account a = new Account();
        a.Name = 'test';
        insert a;



        Opportunity op = new Opportunity();
        op.Name = 'test';
        op.StageName = 'test';
        op.CloseDate = Date.today().addYears(-1);
        insert op;


        //----- This is for opps attached documents
        ContentVersion content=new ContentVersion();
        content.Title='Testing the File';
        content.PathOnClient='TESTfile.pdf';
        content.VersionData=Blob.valueOf('Test Content');
        insert content;

        insert new ContentDocumentLink (ContentDocumentId = [SELECT Id FROM ContentDocument LIMIT 1].Id, LinkedEntityId = [SELECT Id, Name FROM Opportunity where Name = 'test'].Id, ShareType = 'I');
        //-----

    }

    @IsTest
    public static void getAccountsTest(){
        Test.startTest();
        List<Account> accounts = FileListCtrl.getAccounts();
        Test.stopTest();
        System.assert(accounts <> null);

    }

    @IsTest
    public static void getOppIdWithAppNumTest(){
        Test.startTest();
        String opp = FileListCtrl.getOppIdWithAppNum('test');
        Test.stopTest();
        System.assert(opp <> null);
    }

    @IsTest
    public static void getFilesWithAppNumTest(){
        Test.startTest();
        List <AttachedContentDocument> files = FileListCtrl.getFilesWithAppNum('test');
        Test.stopTest();
        System.assert(files <> null);
    }

    @IsTest
    public static void getPublicFilesAppNumTest(){
        Test.startTest();
        List <Content_Distribution_Wrapper__c> wrappers = FileListCtrl.getPublicFilesAppNum('test');
        Test.stopTest();
        System.assert(wrappers <> null);
    }


}