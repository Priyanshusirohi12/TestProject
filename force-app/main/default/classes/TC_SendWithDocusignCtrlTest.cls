/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-22.
 * Description: 
 */

@isTest
public with sharing class TC_SendWithDocusignCtrlTest {

    @TestSetup
    public static void createData() {
        List<UserRole> portalRoles = [SELECT Id FROM UserRole WHERE PortalType = 'None'];
        UserRole portalRole;
        if (portalRoles != null && !portalRoles.isEmpty()) {
            portalRole = portalRoles.get(0);
        }
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User owner = new User(
                ProfileId = profile1.Id,
                UserRoleId = portalRole != null ? portalRole.Id : null,
                Username = 'admin@testclass.org' + System.currentTimeMillis(),
                Alias = 'admin',
                Email = 'admin@testclass.org',
                EmailEncodingKey = 'UTF-8',
                Lastname = 'admin',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Chicago'
        );
        insert owner;

        User u = new User();

        System.runAs(owner) {
            Account acc = new Account(
                    Name = 'test',
                    Counter_Signer_for_Docusign__c = owner.Id,
                    BillingStreet = 'test',
                    BillingCity = 'test',
                    BillingState = 'Minnesota',
                    BillingPostalCode = '12345',
                    Years_in_Business__c = 12
            );
            insert acc;
            Opportunity opp = new Opportunity(
                    Name = 'test',
                    StageName = '010 - Application Entry',
                    CloseDate = System.today(),
                    AccountId = acc.Id
            );
            insert opp;
            Contact con = new Contact(
                    LastName = 'test',
                    AccountId = acc.Id,
                    MailingStreet = 'test',
                    MailingCity = 'test',
                    MailingState = 'Minnesota',
                    MailingPostalCode = '12345'
            );
            insert con;
            Relationship__c rel = new Relationship__c(
                    Related_Opportunity__c = opp.Id,
                    Person__c = con.Id,
                    Percent_of_Ownership__c = 100
            );
            insert rel;
            Equipment__c eq = new Equipment__c(
                    Cost_Per_Unit__c = 100,
                    Quantity__c = 1,
                    Opportunity__c = opp.Id,
                    Name = 'test'
            );

        }
        u = [SELECT Id FROM User where Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Account acc = new Account(
                    Name = 'test1000',
                    Counter_Signer_for_Docusign__c = u.Id,
                    BillingStreet = 'test1000',
                    BillingCity = 'test1000',
                    BillingState = 'Minnesota',
                    BillingPostalCode = '12345',
                    Years_in_Business__c = 12
            );
            insert acc;

            Opportunity opp = new Opportunity(
                    Name = 'test1000',
                    StageName = '010 - Application Entry',
                    CloseDate = System.today(),
                    AccountId = acc.Id
            );
            insert opp;
            insert new Docusign_Settings__c(Docs_In_Stage__c='030 - Credit Decision',Docs_Out_Stage__c='030 - Credit Decision',Use_Stage_Updates__c=true,Default_Counter_Signer__c = u.Id);

        }
    }

    @IsTest
    public static void test(){

        Test.setMock(HttpCalloutMock.class, new TC_DocusignServiceMock());
        Test.startTest();
        List<Opportunity> opps = (List<Opportunity>) Database.query(TC_DataUtility.createSelectAllQueryString ('Opportunity', null, null));
        System.debug('<><><><><> opps: ' + opps);
        List<Account> accs = (List<Account>) Database.query(TC_DataUtility.createSelectAllQueryString ('Account', null, null));
        List<Contact> cons = (List<Contact>) Database.query(TC_DataUtility.createSelectAllQueryString ('Contact', null, null));
        List<Relationship__c> rels = (List<Relationship__c>) Database.query(TC_DataUtility.createSelectAllQueryString ('Relationship__c', null, null));
        List<Equipment__c> equipment = (List<Equipment__c>) Database.query(TC_DataUtility.createSelectAllQueryString ('Equipment__c', null, null));
        List<String> templateIds = new List<String>{
                'test'
        };
        TC_SendWithDocusignCtrl.getTemplates(opps[0].Id);
        TC_SendWithDocusignCtrl.getSigners(opps[0].Id);
        TC_SendWithDocusignCtrl.getUserandAccountInformation(opps[0].Id);
        TC_SendWithDocusignCtrl.send(opps[0].Id, JSON.serialize(rels), 'test', 'test', templateIds, null, accs[0].Id);
        TC_DocusignUtility.testDummy();
        Test.stopTest();

    }

}