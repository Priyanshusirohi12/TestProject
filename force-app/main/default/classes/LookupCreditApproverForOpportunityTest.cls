/**
 * Created on 2019-02-03.
 */
@isTest
private class LookupCreditApproverForOpportunityTest {
    @isTest
    private static void testApprover () {
        List<User> portalUsers = [SELECT Id, Credit_Authority__c FROM User WHERE IsActive = true AND ContactId != null];
        User portalUser = null;
        if (portalUsers != null && portalUsers.size() > 0) {
            portalUser = portalUsers.get(0);
        }
        if (portalUser != null) {
            portalUser.Credit_Authority__c = 50000;
            update portalUser;
        }

        Opportunity opp = new Opportunity();
        opp.CloseDate = System.today();
        opp.StageName = '001 - Saved Deal';
        opp.Amount = 51000;
        if (portalUser != null) {
            opp.OwnerId = portalUser.Id;
        }
        opp.Name = 'sample';

        insert opp;

        Test.startTest();
        //if (portalUser != null) {
        //System.runAs(portalUser) {
        opp.StageName = '030 - Credit Decision';
        opp.Audited__c = True;
        update opp;

        LookupCreditApproverForOpportunity.getApprovers(new List <String> {opp.Id});
        //}
        //}


        Test.stopTest();



    }
}