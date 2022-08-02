/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-20.
 * Description: 
 */

@IsTest
private class TC_DocusignServiceTest {
    @testSetup
    private static void createData() {
        Account a = new Account(Name = 'Test', Approved__c = true);
        insert a;

        Contact c = new Contact(AccountId = a.Id, FirstName = 'First', LastName = 'Last', Email = 'fl@work.com');//, Authorized_QuickFi_User__c = 'Authorized');
        insert c;

        Opportunity o = new Opportunity(Name = 'Test', CloseDate = System.today(), StageName = 'Booking', AccountId = a.Id, Payment__c = 1000, Payment_Tax_Amount__c = 100);
        insert o;

        insert new Equipment__c(Opportunity__c = o.Id);

        insert new Quote_Option__c(Opportunity__c = o.Id, Number_of_Months__c = 36);
    }

    @IsTest
    static void saveDocuments() {
        Test.setMock(HttpCalloutMock.class, new TC_DocusignServiceMock());
        Test.startTest();
        TC_DocusignService.removeFileType('foo.pdf');
        TC_DocusignService.removeFileType('foo.docx');
        TC_DocusignService.saveDocuments('12345', (String) [SELECT Id FROM Opportunity LIMIT 1].Id, '67890', '0058A000001tYp2');
        List<String> docInfo = new List<String>{'test_____12345'};
        TC_DocusignService.saveSeparateDocs('12345',(String) [SELECT Id FROM Opportunity LIMIT 1].Id, '67890', docInfo, '0058A000001tYp2');
        Test.stopTest();
    }

    @IsTest
    static void getAccountInfo() {
        Test.setMock(HttpCalloutMock.class, new TC_DocusignServiceMock());
        Test.startTest();
        TC_DocusignService.getAccountInfo();
        Test.stopTest();
    }

    @IsTest
    static void getDefaultAccount() {
        Test.setMock(HttpCalloutMock.class, new TC_DocusignServiceMock());
        Test.startTest();
        TC_DocusignService.getDefaultAccount();
        Test.stopTest();
    }
}