/**
 * Created by szheng on 2019-06-28.
 */

@isTest
public with sharing class TC_ContentDocumentLinkTriggerHelperTest {

    @isTest
    static void testUpdateAccountLogo() {
        Account acct = new Account(Name = 'TEST_ACCT');
        insert acct;

        ContentVersion contentVersion1 = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion1;

        Opportunity opp = new Opportunity(Name='Test Opportunity',StageName='010 - Application Entry',CloseDate=Date.today());
        insert opp;
        ContentVersion contentVersion2 = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion2;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocument doc = new ContentDocument(Id = documents[0].id, Title = 'accountLogo');
        upsert doc;

        ContentDocumentLink cdl1 = New ContentDocumentLink();
        cdl1.LinkedEntityId = acct.id;
        cdl1.ContentDocumentId = documents[0].Id;
        cdl1.shareType = 'V';
        insert cdl1;

        ContentDocumentLink cdl2 = New ContentDocumentLink();
        cdl2.LinkedEntityId = opp.id;
        cdl2.ContentDocumentId = documents[1].Id;
        cdl2.shareType = 'V';
        insert cdl2;

    }

    @isTest
    static void testPushCreditReporttoOpportunity() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'TCCDLTr', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='TC_CDLTriggerHelper@test.com');


        System.runAs(u) {

            Account account = new Account(Name = 'TEST ACCOUNT');
            insert account;

            Contact contact = new Contact(FirstName = 'PG1', LastName = 'Contact', AccountId = account.Id);
            insert contact;

            Opportunity opp = new Opportunity(Name = 'Test Opp', StageName = 'Test Stage'
                    , CloseDate = Date.today() + 10, AccountId = account.Id);
            insert opp;

            List<Relationship__c> relationshipList = new List<Relationship__c>();
            Relationship__c newRelPersonal = new Relationship__c(RecordType = new RecordType(Name = 'Individual'),
                    Person__c = contact.Id, Related_Opportunity__c = opp.Id);
            relationshipList.add(newRelPersonal);
            insert relationshipList;

            ContentVersion contentVersion = new ContentVersion(
                    Title = 'Penguins',
                    PathOnClient = 'Penguins.pdf',
                    VersionData = Blob.valueOf('Test Content'),
                    IsMajorVersion = true
            );
            insert contentVersion;

            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            ContentDocument doc = new ContentDocument(Id = documents[0].id, Title = 'testCreditReport');
            upsert doc;

            sObject report;
            report = contact;

            ContentDocumentLink cdl1 = New ContentDocumentLink();
            cdl1.LinkedEntityId = report.Id;
            cdl1.ContentDocumentId = documents[0].Id;
            cdl1.shareType = 'V';
            insert cdl1;

        }

    }
}