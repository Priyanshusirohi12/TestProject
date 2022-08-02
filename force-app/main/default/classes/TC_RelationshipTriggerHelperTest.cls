@isTest public class TC_RelationshipTriggerHelperTest {
    @isTest public static void setupRels () {

        insert new Origination_Setting__c (Enable_Personal_Guarantor_Priorities__c = true);

        Account acc = new Account (Name = 'test');
        insert acc;

        Contact con = new Contact (LastName = 'test', AccountId = acc.Id, Is_Corporate_Officer__c = true);
        insert con;


        Opportunity opp = new Opportunity (Name = 'after', StageName = 'tes', CloseDate = Date.today () + 10);
        insert opp;

        Relationship__c rel = new Relationship__c (Business__c = acc.Id, Relationship_Type__c = 'Business Guarantee', Related_Opportunity__c = opp.Id);
        insert rel;

        rel.Person__c = con.Id;
        rel.Relationship_Type__c = 'Personal Guarantee';
        rel.Priority__c = 1;
        rel.Business__c = NULL;
        update rel;


    }


    @IsTest public static void testAfter(){

        List<Opportunity> oppList = [SELECT Id FROM Opportunity];


        Test.startTest();
        TC_RelationshipTriggerHelper.afterOpportunity (oppList, oppList);
        Test.stopTest();

    }
    

}