/**
 * Created by eschneider on 10/26/20.
 */

@IsTest
private class TC_OnlineApplicationSubmitCtrlTest {
    @testSetup
    private static void createData () {

        Group g = new Group();
        g.DeveloperName = 'ABC_Lender_Queue';
        g.Name = 'ABC_Lender_Queue';
        g.type='Queue';
        insert g;


        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueueSobject qo = new QueueSobject();
            qo.QueueId = g.Id;
            qo.SobjectType = 'Lead';
            insert qo;
        }

        Account partnerAccount = TestUtility.createAccount('Partner Account');
        partnerAccount.RecordType = new RecordType(Name = 'Broker');
        insert partnerAccount;

        Account vendorAccount = TestUtility.createAccount('Vendor Account');
        vendorAccount.RecordType = new RecordType(Name = 'Vendor');
        insert vendorAccount;

        Application_Program__c applicationProgram = new Application_Program__c(Vendor__c = vendorAccount.Id, Active__c = TRUE);
        insert applicationProgram;

        Application_Program__c applicationProgram2 = new Application_Program__c(Vendor__c = partnerAccount.Id, Active__c = TRUE);
        insert applicationProgram2;

        Origination_Setting__c originationSetting = new Origination_Setting__c(Own_Company_Account_Id__c = partnerAccount.Id);
        insert originationSetting;

        Lead lead = new Lead(LastName='Lead Last Name', Company='Lead Company');
        insert lead;


        ContentVersion contentVersion1 = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion1;

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


    }

    @IsTest
    static void testBehavior() {

        List<Account> accountList = new List<Account>([SELECT Id, RecordType.Name FROM Account]);
        String vendorId;
        for (Account acc : accountList) {
            if (acc.RecordType.Name == 'Vendor') vendorId = acc.Id;
        }
        Test.startTest();
        //String urlParameters = '{"Guarantor_Annual_Income_2__c":1000,"Equipment_Price_2__c":100,"Custom_Field_1_Label__c":"8","Last_Name_2__c":"Name","Equipment_Quantity__c":"1","Equipment_Price__c":"100","Equipment_Description__c":"Test"}';
        TC_OnlineApplicationCtrl wrapper = TC_OnlineApplicationCtrl.doApplicationInit('', vendorId, null, '');
        System.debug('>>>wrapper: '+wrapper);
        System.debug('>>>wrapper.businessSectionWrapper: '+wrapper.businessSectionWrapper);
        wrapper.businessSectionWrapper.sObjectRecord.put('Authorized_Credit_Check__c', true);
        wrapper.businessSectionWrapper.sObjectRecord.put('Company', 'Test company');
        wrapper.primaryContactSectionWrapper.sObjectRecord.put('LastName', 'Name');
        wrapper.primaryContactSectionWrapper.sObjectRecord.put('Email', 'test@test.com');
        wrapper.equipmentSectionWrapperList = new List<TC_OnlineApplicationCtrl.SectionWrapper>();
        TC_OnlineApplicationCtrl.SectionWrapper equip = new TC_OnlineApplicationCtrl.SectionWrapper();
        equip.existBoolean = false;
        equip.sObjectRecord = new Lead();
        equip.sObjectRecord.put('Equipment_Price_2__c', 100);
        equip.sObjectRecord.put('Equipment_Description__c', 'Test');
        equip.sObjectRecord.put('Equipment_Quantity__c', 1);
        wrapper.equipmentSectionWrapperList.add(equip);
        wrapper.guarantorSectionWrapperList = new List<TC_OnlineApplicationCtrl.SectionWrapper>();
        TC_OnlineApplicationCtrl.SectionWrapper guar = new TC_OnlineApplicationCtrl.SectionWrapper();
        guar.existBoolean = false;
        guar.sObjectRecord = new Lead();
        guar.sObjectRecord.put('Last_Name_2__c', 'Test');
        wrapper.guarantorSectionWrapperList.add(guar);
        TC_OnlineApplicationSubmitCtrl.createLead(wrapper);
        TC_OnlineApplicationSubmitCtrl.submitFollowUp(wrapper);
        TC_OnlineApplicationSubmitCtrl.attachGuestFileUploads(wrapper);
        Test.stopTest();
    }


    @IsTest
    static void testPDF() {

        Account account = [SELECT Id, RecordType.Name FROM Account LIMIT 1];
        Lead lead = [SELECT Id FROM Lead LIMIT 1];
        ContentDocument doc = [SELECT Id FROM ContentDocument LIMIT 1];


        Test.startTest();

        Test.setCurrentPage(Page.TC_OnlineApplicationPDF);
        ApexPages.currentPage().getParameters().put('cdList', doc.Id);
        ApexPages.currentPage().getParameters().put('leadId', lead.Id);
        ApexPages.currentPage().getParameters().put('partnerCode', account.Id);
        ApexPages.currentPage().getParameters().put('vendorId', account.Id);

        TC_OnlineApplicationPDFCtrl pdf = new TC_OnlineApplicationPDFCtrl();

        Test.stopTest();

    }
}