@isTest public class TC_OriginatorHelperTest {
    
    @isTest public static void testAppToBroker () {
        Account broker = new Account (Name = 'Broker'
                                    , RecordTypeId = SObjectType.Account.getRecordTypeInfosByName().get('Broker/Dealer').getRecordTypeId()
                                    , Website = 'www.test.com');
        insert broker;
        
        Contact brokerContact = new Contact (FirstName = 'fname', LastName = 'lname', AccountId = broker.Id, Email = 'test@test.com');
        insert brokerContact;
        
        
        insert new Lead (Originator_Email__c = 'test@test.com', Company = 'test', LastName = 'test', FirstName = 'test');
        insert new Opportunity (Originator_Email__c = 'test@test.com', StageName = 'test', CloseDate = Date.today () + 10, Name = 'test');
    }
    
    @isTest public static void testBrokerToApp () {
    
        insert new Lead (Originator_Email__c = 'test@test.com', Company = 'test', LastName = 'test', FirstName = 'test');
        insert new Opportunity (Originator_Email__c = 'test@test.com', StageName = 'test', CloseDate = Date.today () + 10, Name = 'test');
        
        Account broker = new Account (Name = 'Broker'
                                    , RecordTypeId = SObjectType.Account.getRecordTypeInfosByName().get('Broker/Dealer').getRecordTypeId()
                                    , Website = 'www.test.com');
        insert broker;
        
        Contact brokerContact = new Contact (FirstName = 'fname', LastName = 'lname', AccountId = broker.Id, Email = 'test@test.com');
        insert brokerContact;
        
        
        
    }

}