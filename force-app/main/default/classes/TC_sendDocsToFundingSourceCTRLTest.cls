/**
 * Created by szheng on 2019-12-03.
 */

@isTest
public with sharing class TC_sendDocsToFundingSourceCTRLTest {

    @testSetup
    public static void createTestData() {

        List<Account> accountList = new List<Account>();
        Account account1 = new Account(Name = 'CG1 Account');
        accountList.add(account1);
        Account account2 = new Account(Name = 'Lender1 Account', RecordType = new RecordType(Name = 'Lender')
                ,Funding_Email__c = 'test1@test.com');
        accountList.add(account2);
        Account account3 = new Account(Name = 'Lender2 Account', RecordType = new RecordType(Name = 'Lender')
                ,Funding_Email__c = 'test2@test.com');
        accountList.add(account3);
        insert accountList;


        Contact contact1 = new Contact(FirstName = 'PG1', LastName = 'Contact', AccountId = account1.Id);
        insert contact1;

        Opportunity opp = new Opportunity(Name = 'Test Opp', StageName = 'Test Stage'
                , CloseDate = Date.today() + 10, AccountId = account1.Id);
        insert opp;

        List<Relationship__c> relationshipList = new List<Relationship__c>();
        Relationship__c newRelPersonal = new Relationship__c(RecordType = new RecordType(Name = 'Individual'),
                Person__c = contact1.Id, Related_Opportunity__c = opp.Id);
        relationshipList.add(newRelPersonal);
        Relationship__c newRelCorporate = new Relationship__c(RecordType = new RecordType(Name = 'Corporation'),
                Business__c = account1.Id, Related_Opportunity__c = opp.Id);
        relationshipList.add(newRelCorporate);
        insert relationshipList;


        ContentVersion contentVersionInsert = new ContentVersion(
                Title = 'Test',
                PathOnClient = 'Test.jpg',
                VersionData = Blob.valueOf('Test Content Data'),
                IsMajorVersion = true
        );
        insert contentVersionInsert;

        List<ContentDocument> cdList = new List<ContentDocument>([
                SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument]);

        ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId = opp.Id
                , ContentDocumentId = cdList[0].Id, shareType = 'V');
        insert cdl;

    }

    @isTest
    public static void setWizardWrapperTest() {

        List<Opportunity> oppList = new List<Opportunity>([SELECT Id FROM Opportunity WHERE Name = 'Test Opp' LIMIT 1]);
        Id recordId = oppList[0].Id;

        Test.startTest();
        TC_sendDocsToFundingSourceCTRL.setWizardWrapper(recordId);
        Test.stopTest();

    }

    @isTest
    public static void selectLenderTest() {

        List<Account> accList = new List<Account>([SELECT Id FROM Account WHERE Name = 'Lender1 Account']);
        Id recordId = accList[0].Id;

        Test.startTest();
        TC_sendDocsToFundingSourceCTRL.selectLender(recordId);
        Test.stopTest();

    }

    public static String createfsWrapperListString(List<Account> lenderList, Id recordId) {

        List<TC_sendDocsToFundingSourceCTRL.fsWrapper> fsWrapperList = new List<TC_sendDocsToFundingSourceCTRL.fsWrapper>();

        Account lender1 = lenderList[0];
        Funding_Source__c fs1 = new Funding_Source__c(Status__c = 'Submitted', Funding_Source__c = lender1.Id
                , Related_Opportunity__c = recordId);
        fsWrapperList.add(new TC_sendDocsToFundingSourceCTRL.fsWrapper(lender1.Funding_Email__c, lender1, fs1, true));

        Account lender2 = lenderList[1];
        fsWrapperList.add(new TC_sendDocsToFundingSourceCTRL.fsWrapper(lender2.Funding_Email__c, lender2, null, false));

        return JSON.serialize(fsWrapperList);

    }

    @isTest
    public static void setFundingSourceRecordsTest() {

        Map<String, String> setFSRecordMap = new Map<String, String>();

        List<Account> lenderList = new List<Account>([
                SELECT Id, Funding_Email__c
                FROM Account
                WHERE Name = 'Lender1 Account' OR Name = 'Lender2 Account']);
        String lenderListString = JSON.serialize(LenderList);

        List<String> selectedEmailList = new List<String>{
                lenderList[0].Funding_Email__c, lenderList[1].Funding_Email__c, 'test3@test.com'};
        String selectedEmailListString = JSON.serialize(selectedEmailList);

        List<Opportunity> oppList = new List<Opportunity>([SELECT Id FROM Opportunity LIMIT 1]);
        Id recordId = oppList[0].Id;

        setFSRecordMap.put('lenderList', lenderListString);
        setFSRecordMap.put('selectedEmailList', selectedEmailListString);
        setFSRecordMap.put('recordId', recordId);
        setFSRecordMap.put('fsWrapperList', createfsWrapperListString(lenderList, recordId));

        String setFSRecordMapString = JSON.serialize(setFSRecordMap);

        Test.startTest();
        TC_sendDocsToFundingSourceCTRL.setFundingSourceRecords(setFSRecordMapString);
        Test.stopTest();

    }

    @isTest
    public static void sendEmailWithFiles() {

        Map<String, String> sendEmailMapParams = new Map<String, String>();

        List<Opportunity> oppList = new List<Opportunity>([SELECT Id FROM Opportunity WHERE Name = 'Test Opp' LIMIT 1]);
        Id recordId = oppList[0].Id;

        TC_sendDocsToFundingSourceCTRL.wizardWrapper wrapper = TC_sendDocsToFundingSourceCTRL.setWizardWrapper(recordId);

        List<Account> lenderList = new List<Account>([
                SELECT Id, Funding_Email__c
                FROM Account
                WHERE Name = 'Lender1 Account' OR Name = 'Lender2 Account']);

        List<String> selectedEmailList = new List<String>{
                lenderList[0].Funding_Email__c, lenderList[1].Funding_Email__c, 'test3@test.com'};

        sendEmailMapParams.put('fileWrapperListString', JSON.serialize(wrapper.fileWrapperList));
        sendEmailMapParams.put('selectedEmailListString', JSON.serialize(selectedEmailList));
        sendEmailMapParams.put('emailWrapperString', JSON.serialize(wrapper.emailWrapper));
        sendEmailMapParams.put('fsWrapperListString', createfsWrapperListString(lenderList, recordId));

        String sendEmailMapParamsString = JSON.serialize(sendEmailMapParams);

        Test.startTest();
        TC_sendDocsToFundingSourceCTRL.sendEmailWithFiles(sendEmailMapParamsString);
        Test.stopTest();

    }

}