/**
 * Created by szheng on 2019-09-06.
 * Tests for all controllers used for the Deal Entry Wizard:
 *      TC_DealEntryWizardCtrl
 *      TC_DealEntryCompanyCtrl
 *      TC_DealEntryGuarantorsCtrl
 *      TC_DealEntryPartnerCtrl
 */

@isTest
public with sharing class TC_DealEntryCtrlTest {

    @testSetup
    public static void createTestData() {
        List<Account> accountList = new List<Account>();
        Account account1 = new Account(Name = 'Test Company');
        accountList.add(account1);
        Account account2 = new Account(Name = 'Create Test Company CG');
        accountList.add(account2);
        insert accountList;

        List<Contact> contactList = new List<Contact>();
        Contact contact1 = new Contact(FirstName = 'Deal Entry', LastName = 'Wizard Contact', AccountId = account1.Id);
        contactList.add(contact1);
        Contact contact2 = new Contact(FirstName = 'Create Test', LastName = 'Company PG');
        contactList.add(contact2);
        insert contactList;

        Opportunity opp = new Opportunity(Name = 'Test Company Related Opportunity', StageName = 'Test Stage'
                , CloseDate = Date.today() + 10, AccountId = account1.Id);
        insert opp;

        List<Relationship__c> relationshipList = new List<Relationship__c>();
        Relationship__c newRelPersonal = new Relationship__c(RecordType = new RecordType(Name = 'Individual'),
                Person__c = contact2.Id, Related_Opportunity__c = opp.Id);
        relationshipList.add(newRelPersonal);
        Relationship__c newRelCorporate = new Relationship__c(RecordType = new RecordType(Name = 'Corporation'),
                Business__c = account2.Id, Related_Opportunity__c = opp.Id);
        relationshipList.add(newRelCorporate);
        insert relationshipList;
    }

    // Tests for TC_DealEntryWizardCtrl
    @isTest
    public static void submitDealCtrlSuccessTest() {

        // dealString
        String dealString = JSON.serialize(new Opportunity(Name = 'Test Opp',
                StageName = 'Test Stage', CloseDate = Date.today() + 10));

        // companyString
        Account account = [SELECT Id FROM Account WHERE Name = 'Test Company' LIMIT 1];
        String companyString = JSON.serialize(account);

        // companyPguarantorString
        List<Relationship__c> companyPguarantorList = new List<Relationship__c>{
                new Relationship__c(Person__r = new Contact(LastName = 'Test Company PG', AccountId = account.Id))
        };
        String companyPguarantorString = JSON.serialize(companyPguarantorList);

        // companyCguarantorString
        List<Relationship__c> companyCguarantorList = new List<Relationship__c>{
                new Relationship__c(Business__r = new Account(Name = 'Test Company CG'))
        };
        String companyCguarantorString = JSON.serialize(companyCguarantorList);

        // pguarantorString
        List<Relationship__c> pguarantorList = new List<Relationship__c>{
                new Relationship__c(Person__r = new Contact(LastName = 'Test PG'))
        };
        String pguarantorString = JSON.serialize(pguarantorList);

        // cguarantorString
        List<Relationship__c> cguarantorList = new List<Relationship__c>{
                new Relationship__c(Business__r = new Account(Name = 'Test CG'))
        };
        String cguarantorString = JSON.serialize(cguarantorList);

        // equipmentString
        List<Equipment__c> equipmentList = new List<Equipment__c> {
                new Equipment__c(Name = 'Test Equipment Description', Cost_Per_Unit__c = 300.0, Quantity__c = 30.0)
        };
        String equipmentString = JSON.serialize(equipmentList);

        // partnerString
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
        String brokerTypeId = recordTypeMap.get('Broker').getRecordTypeId();
        String partnerString = JSON.serialize(new Account(Name = 'Test Partner', RecordTypeId = brokerTypeId));

        TC_DealEntryWizardCtrl.submitDealCtrl(dealString, companyString, companyPguarantorString,
                companyCguarantorString, pguarantorString, cguarantorString, equipmentString, partnerString);

    }

    @isTest
    public static void submitDealCtrlInvalidArgumentTest() {

        try {
            TC_DealEntryWizardCtrl.submitDealCtrl('cannot be deserialized', null, null, null, null, null, null, null);
        } catch (Exception e) {
            System.assertEquals('System.AuraHandledException', e.getTypeName());
        }

    }

    @isTest
    public static void initMethodSuccessTest() {
        TC_DealEntryWizardCtrl.initMethod();
    }

    /*@isTest
    public static void getRecordTypePicklistRegularUserTest() {
        Map<String, String> recordTypeMap = TC_DealEntryWizardCtrl.setDealOptions();
        System.assert(recordTypeMap.containsKey('Equipment Finance'));
        System.assert(!recordTypeMap.containsKey('Broker Equipment Finance'));
    }

    @isTest
    public static void getRecordTypePicklistLKEFBrokerUserTest() {
        Profile LKEFBrokerProfile = [SELECT Name, Id FROM Profile WHERE Name = 'LK EF Broker' LIMIT 1];

        if (LKEFBrokerProfile != null) {
            Account newAccount = new Account(Name = 'Test Account');
            insert newAccount;

            Contact newContact = new Contact(LastName = 'Test Contact', AccountId = newAccount.Id);
            insert newContact;

            User user1 = new User(Alias = 'standt1',Country ='United Kingdom',Email = 'demo1@randomdemodomain.com',
                    EmailEncodingKey ='UTF-8', LastName='Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                    ProfileId = LKEFBrokerProfile.Id, TimeZoneSidKey = 'America/Los_Angeles',
                    UserName = 'getRecordTypePicklistLKEFBrokerUserTest@e.com', ContactId = newContact.Id);
            insert user1;

            System.runAs(user1) {
                Map<String, String> recordTypeMap = TC_DealEntryWizardCtrl.getDealRecordTypes();
                System.assert(recordTypeMap.containsKey('Broker Equipment Finance'));
                System.assert(!recordTypeMap.containsKey('Equipment Finance'));
            }
        }
    }*/

    // Tests for TC_DealEntryCompanyCtrl
    @isTest
    public static void getRecordTypeId() {
        TC_DealEntryCompanyCtrl.getRecordTypeId();
    }

    @isTest
    public static void selectCompanySuccessTest() {

        TC_DealEntryWizardCtrl.TC_DealWizardWrapper wrapper = new TC_DealEntryWizardCtrl.TC_DealWizardWrapper();

        Account account = [SELECT Id FROM Account WHERE Name = 'Test Company' LIMIT 1];
        wrapper.companyWrapper.company = account;

        String wrapperString = JSON.serialize(wrapper);

        TC_DealEntryCompanyCtrl.selectCompany(wrapperString);
    }

    @isTest
    public static void selectCompanyInvalidArgumentTest() {
        try {
            TC_DealEntryCompanyCtrl.selectCompany('invalidId');
        } catch (Exception e) {
            System.assertEquals('System.JSONException', e.getTypeName());
        }
    }

    // Tests for TC_DealEntryGuarantorsCtrl
    @isTest
    public static void getRecordTypeGuarantorsTest() {
        TC_DealEntryGuarantorsCtrl.getRecordType();
    }

    @isTest
    public static void getRecordTypePicklistGuarantorContactTest() {
        TC_DealEntryGuarantorsCtrl.getRecordTypePicklist();
    }

    @isTest
    public static void selectPGContactSuccessTest() {
        TC_DealEntryWizardCtrl.TC_DealWizardWrapper wrapper = new TC_DealEntryWizardCtrl.TC_DealWizardWrapper();
        String wrapperString = JSON.serialize(wrapper);

        Contact contact = [SELECT Id FROM Contact WHERE NAME = 'Deal Entry Wizard Contact' LIMIT 1];
        String contactId = (String) contact.Id;

        TC_DealEntryGuarantorsCtrl.selectPGuarantorCtrl(wrapperString, contactId, 0);
    }

    @isTest
    public static void selectPGContactInvalidArgumentTest() {
        try {
            TC_DealEntryGuarantorsCtrl.selectPGuarantor('invalidId');
        } catch (Exception e) {
            System.assertEquals('System.AuraHandledException', e.getTypeName());
        }
    }

    @isTest
    public static void selectCGAccountSuccessTest() {
        TC_DealEntryWizardCtrl.TC_DealWizardWrapper wrapper = new TC_DealEntryWizardCtrl.TC_DealWizardWrapper();
        String wrapperString = JSON.serialize(wrapper);

        Account account = [SELECT Id FROM Account WHERE Name = 'Test Company' LIMIT 1];
        String accountId = (String) account.Id;

        TC_DealEntryGuarantorsCtrl.selectCGuarantorCtrl(wrapperString, accountId, 0);
    }

    @isTest
    public static void selectCGAccountInvalidArgumentTest() {
        try {
            TC_DealEntryGuarantorsCtrl.selectCGuarantor('invalidId');
        } catch (Exception e) {
            System.assertEquals('System.AuraHandledException', e.getTypeName());
        }
    }

    // Tests for TC_DealEntryPartnerCtrl
    @isTest
    public static void getRecordTypePicklistPartnerTest() {
        TC_DealEntryPartnerCtrl.getRecordTypeId();
    }

    @isTest
    public static void selectPartnerAccountSuccessTest() {
        Account newAccount = new Account(Name = 'selectPartnerAccountSuccessTest');
        insert newAccount;

        Account response = TC_DealEntryPartnerCtrl.selectPartner(newAccount.Id);
        System.assertEquals('selectPartnerAccountSuccessTest', response.Name);
    }

    @isTest
    public static void selectParnterAccountInvalidArgumentTest() {
        try {
            TC_DealEntryPartnerCtrl.selectPartner('invalidId');
        } catch (Exception e) {
            System.assertEquals('System.AuraHandledException', e.getTypeName());
        }
    }

}