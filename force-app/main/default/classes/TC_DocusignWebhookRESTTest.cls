/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-20.
 * Description: 
 */

@IsTest
private class TC_DocusignWebhookRESTTest {
    @testSetup
    private static void createData() {
        Account a = new Account(Name = 'Test', Approved__c = true);
        insert a;

        Contact con = new Contact(AccountId = a.Id, FirstName = 'First', LastName = 'Last', Email = 'fl@work.com');
        insert con;

        Opportunity o = new Opportunity(Name = 'Test', CloseDate = System.today(), StageName = 'Booking', AccountId = a.Id);
        insert o;

        insert new Equipment__c(Opportunity__c = o.Id);

        insert new Quote_Option__c(Opportunity__c = o.Id, Number_of_Months__c = 36);

        insert new TC_Docusign_Envelope__c(Name = '', Envelope_Id__c = '1234567890', Opportunity__c = o.Id, Account_Id__c = 'kj12h4l1k2jnnnjnk1j23k');

        insert new Docusign_Settings__c(Docs_In_Stage__c='030 - Credit Decision',Docs_Out_Stage__c='030 - Credit Decision',Use_Stage_Updates__c=true);

    }

    @IsTest
    static void doPost() {
        Test.setMock(HttpCalloutMock.class, new TC_DocusignServiceMock());
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = '/docusignWebhook';
        request.httpMethod = 'POST';

        request.requestBody = Blob.valueOf('<DocuSignEnvelopeInformation><EnvelopeStatus><EnvelopeID>1234567890</EnvelopeID><Subject>QuickFi User Authorization</Subject><Status>Completed</Status></EnvelopeStatus></DocuSignEnvelopeInformation>');
        RestContext.request = request;
        TC_DocusignWebhookREST.doPost();

        request.requestBody = Blob.valueOf('<DocuSignEnvelopeInformation><EnvelopeStatus><EnvelopeID>1234567890</EnvelopeID><Subject>QuickFi Contract</Subject><Status>Completed</Status></EnvelopeStatus></DocuSignEnvelopeInformation>');
        RestContext.request = request;
        TC_DocusignWebhookREST.doPost();

        request.requestBody = Blob.valueOf('<DocuSignEnvelopeInformation><EnvelopeStatus><EnvelopeID>1234567890</EnvelopeID><Subject>QuickFi Contract</Subject><Status>Sent</Status><RecipientStatuses><RecipientStatus><Email>Email</Email><RoutingOrder>1</RoutingOrder><Status>Completed</Status></RecipientStatus></RecipientStatuses></EnvelopeStatus></DocuSignEnvelopeInformation>');
        RestContext.request = request;
        TC_DocusignWebhookREST.doPost();
        Test.stopTest();
    }
}