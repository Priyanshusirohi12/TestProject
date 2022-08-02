@isTest
public class TC_AutoApprovalTest {
    @isTest
    static void test() {

        Account a = new Account();
        a.Name = 'test';
        insert a;

        Opportunity opp = new Opportunity();
        opp.name = 'Test';
        opp.CloseDate = Date.today();
        opp.Amount = 123.45;
        opp.StageName = 'test';
        opp.AccountId = a.Id;
        insert opp;



        Id userId = UserInfo.getUserId();

        // Need to adjust for local org approval process
        TC_AutoApprovalUtility manual = new TC_AutoApprovalUtility();
        manual.submitComment = 'AUTO Submitting for manual approval';
        manual.skipEntryCriteria = TRUE;
        manual.submitToProcess('Manual_Approval_Process', opp.Id, userId);

        try {
            manual.rejectProcess(userId);
        } catch (Exception e) {
            System.debug('Reject process failed. ERROR: ' + e.getMessage());
        }


        manual.submitComment = 'AUTO Submitting for manual approval';
        manual.submitToProcess('Manual_Approval_Process', opp.Id, userId);

        try {
            manual.approveProcess(userId);
        } catch (Exception e) {
            System.debug('Approval process failed. ERROR: ' + e.getMessage());
        }


        TC_AutoApprovalUtility.getApprovalHistory(opp.Id);






        TC_AutoApproval.run(new List<Id>{opp.Id});



        TC_AutoApprovalUtility.getApprovalHistory(opp.Id);




    }
}