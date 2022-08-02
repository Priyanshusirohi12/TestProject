@IsTest
public with sharing class GreenDoorFileListCtrlTest {

    @TestSetup
    public static void setUP(){
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
    public static void getFilesForRecordIdTest(){
        Opportunity op = [SELECT Id FROM Opportunity LIMIT 1].get(0);
        Test.startTest();
        List <ContentVersion> contentVersions = GreenDoorFileListCtrl.getFilesForRecordId(op.Id);
        Test.stopTest();
        System.assert(contentVersions <> null);
    }

}