@IsTest
public with sharing class TC_DocRequestFormCtrlLtngTest {
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
    static void grabDocWrapperTest() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        TC_DocRequestFormCtrlLtng.grabDocWrapper(opp.Id);
        Test.stopTest();
    }

}