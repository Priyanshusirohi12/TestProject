@isTest
private class TC_Invoice_CtrlLtngTest {
    
    @testSetup
    private static void testRunAs() {
            // Setup test data
            // Create a unique UserName
            String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
            // This code runs as the system user
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
             UserName=uniqueUserName);
    
            System.runAs(u) {
                  // The following code runs as user 'u'
                  System.debug('Current User: ' + UserInfo.getUserName());
                  System.debug('Current Profile: ' + UserInfo.getProfileId());
              }
        }
            /*
        @testSetup
        private static void createData() {
            
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile p = [SELECT Id FROM Profile WHERE Name='LK EF Lender'];
            Account objAcc = new Account(name ='Test Account');
            Contact objContact = new Contact(LastName ='testCon',AccountId = objAcc.Id);
            
            User u = new User(Alias = 'newUser', Email='newuser@testorg.com',
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=portalRole.Id,contactId=objContact.id,
                 TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
            
            insert u; 
        }*/

    @isTest
    static void testValidInvoice() {
        Opportunity opp = new Opportunity(Name='Test Opportunity',StageName='010 - Application Entry',CloseDate=Date.today(),Invoice_Number__c=100);
        insert opp;
        Id lender = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lender').getRecordTypeId();
        Account a = new Account(Name='Test Account',RecordTypeId=lender);
        insert a;
        Funding_Source__c f = new Funding_Source__c(Doc_Fee__c=100, Commission__c=5,Related_Opportunity__c=opp.id,Selected__c=True,Funding_Source__c=a.id);
        insert f;
        
        Test.startTest();
        tc_InvoiceCtrlLtng.grabInvoiceWrapper(opp.id);
        Test.stopTest();
    }
    
    @isTest
    static void testMissingFundingSource() {
        Opportunity opp = new Opportunity(Name='Test Opportunity',StageName='010 - Application Entry',CloseDate=Date.today(),Invoice_Number__c=100);
        Id lender = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lender').getRecordTypeId();
        Account a = new Account(Name='Test Account',RecordTypeId=lender);
        insert a;
        insert opp;
        Funding_Source__c f = new Funding_Source__c(Doc_Fee__c=100, Commission__c=5,Related_Opportunity__c=opp.id,Selected__c=False,Funding_Source__c=a.id);
        insert f;
        
        Test.startTest();
        tc_InvoiceCtrlLtng.grabInvoiceWrapper(opp.id);
        Test.stopTest();
    }
    
    
    @isTest
    static void testMissingDetails() {
        // Missing Funding Source doc + commission fee details
        // Missing Opportunity invoice number
        Opportunity opp = new Opportunity(Name='Test Opportunity',StageName='010 - Application Entry',
                                          CloseDate=Date.today());
        insert opp;
        Id lender = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lender').getRecordTypeId();
        Account a = new Account(Name='Test Account',RecordTypeId=lender);
        insert a;
        Funding_Source__c f = new Funding_Source__c(Related_Opportunity__c=opp.id,Funding_Source__c=a.id,Selected__c=True);
        insert f;
        
        Test.startTest();
        tc_InvoiceCtrlLtng.grabInvoiceWrapper(opp.id);
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateOpportunity() {
        Opportunity opp = new Opportunity(Name='Test Opportunity',StageName='010 - Application Entry',
                                          CloseDate=Date.today(),Invoice_Number__c=100);
        insert opp;
        
        Test.startTest();
        tc_InvoiceCtrlLtng.updateOpportunity(opp.id, 100);
        Test.stopTest();
    }
}