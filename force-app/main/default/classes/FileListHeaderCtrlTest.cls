@IsTest
public with sharing class FileListHeaderCtrlTest {
    @TestSetup
    public static void setUP(){
        Account a = new Account();
        a.Name = 'test';
        insert a;

        Opportunity op = new Opportunity();
        op.Name = 'test';
        op.StageName = 'test';
        op.CloseDate = Date.today().addYears(1);
        op.AccountId = a.Id;
        insert op;
    }

    @IsTest
    public static void getOpportunityAndAccountNameTest(){
        Test.startTest();
        String name = FileListHeaderCtrl.getOpportunityAndAccountName('test');
        Test.stopTest();
        System.assert(name <> null);
    }
}