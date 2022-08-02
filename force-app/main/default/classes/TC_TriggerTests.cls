@isTest
private class TC_TriggerTests{
    @isTest
    static void testGenerateRecords() {
        Opportunity opp = new Opportunity ();
        opp.Name = 'Test Opp';
        opp.StageName = 'Declined';
        opp.CloseDate = Date.today();
        insert opp;
        
        Relationship__c rel = new Relationship__c ();
        rel.Related_Opportunity__c = opp.Id;
        insert rel;


    }
}