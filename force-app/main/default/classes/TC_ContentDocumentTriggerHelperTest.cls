/**
 * Created by szheng on 2019-07-05.
 */

@isTest
public with sharing class TC_ContentDocumentTriggerHelperTest {

    // NOTE: This test is only needed/will pass if functionality for auto-generating a URL to an 'accountLogo.png'
    // upload on an Account record is used.
    @isTest
    static void testDeleteAccountLogo() {
        Account acct = new Account(Name = 'TEST_ACCT');
        insert acct;

        ContentVersion contentVersionInsert = new ContentVersion(
                Title = 'accountLogo',
                PathOnClient = 'accountLogo.png',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersionInsert;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocument doc = new ContentDocument(Id = documents[0].id, Title = 'accountLogo');
        upsert doc;

        ContentDocumentLink cdLink = new ContentDocumentLink(
                LinkedEntityId = acct.Id,
                ContentDocumentId = doc.Id,
                ShareType = 'v'
        );
        insert cdLink;

        List<Account> accountsOld = new List<Account>([SELECT Logo_URL__c FROM Account WHERE ID =: acct.Id]);
        if (!accountsOld.isEmpty()) {
            System.assertNotEquals(null, accountsOld[0].Logo_URL__c);
        }

        delete doc;

        List<Account> accountsNew = new List<Account>([SELECT Logo_URL__c FROM Account WHERE ID =: acct.Id]);
        if (!accountsNew.isEmpty()) {
            System.assertEquals(null, accountsNew[0].Logo_URL__c);
        }

    }

}