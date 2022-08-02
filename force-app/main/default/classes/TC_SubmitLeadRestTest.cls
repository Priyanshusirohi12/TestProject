@isTest
public class TC_SubmitLeadRestTest {
    @isTest public static void submitLeadTest ()  {

        insert new Account (Name = 'broker'
                , RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId()
                , API_Authorization_Code__c = 'test1234');

        TC_SubmitLeadRest.submitLead ();
    }
    @isTest public static void submitLeadFailTest ()  {

        insert new Account (Name = 'broker'
                , RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Broker').getRecordTypeId()
                , API_Authorization_Code__c = 'test1234');

        TC_SubmitLeadRest.submitLead ();
    }

    @isTest public static void submitLeadFail2Test ()  {

        insert new Account (Name = 'broker'
                , RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId()
                , API_Authorization_Code__c = 'badcode');

        TC_SubmitLeadRest.submitLead ();
    }
}