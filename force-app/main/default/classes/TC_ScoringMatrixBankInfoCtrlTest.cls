@isTest

private class TC_ScoringMatrixBankInfoCtrlTest {
    @testSetup
    static void setupData () {
        Account acc = new Account ();
        acc.Name = 'Main Account';
        insert acc;
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'Test Opp';
        opp.CloseDate = date.newInstance(2013, 12, 1);
        opp.StageName = 'Approved';
        opp.AccountId = acc.Id;
        insert opp;
        
        Bank_Info__c bankInfo = new Bank_Info__c ();
        bankInfo.Name = 'Wells Fargo';
        bankInfo.Opportunity__c = opp.Id;
        insert bankInfo;
    }
    
    
    @isTest
    static void test () {
        Test.startTest();
        Bank_Info__c bankInfo = [SELECT Id FROM Bank_Info__c LIMIT 1];
        
        TC_ScoringMatrixBankInfoCtrl.initStatements (bankInfo.Id);
        
        List <Bank_Statement__c> bankStatements =
            [SELECT Id
             ,Name
             ,Deposit_Count__c
             ,Bank_Info__r.Name
             ,Bank_Info__r.Average_Deposits__c
             ,Bank_Info__r.Average_Ending_Balance__c
             ,Bank_Info__r.Average_Average_Daily_Bank_Balance__c
             ,Bank_Info__r.Avg_Avg_Daily_Bank_Balance_Rounded__c
             ,Bank_Info__r.Neg_Days_Last_3_Months__c
             ,Bank_Info__r.NSF_OD_Last_3_Months__c
             ,Bank_Info__r.X2nd_Highest__c
             ,Bank_Info__r.X2nd_Lowest__c
             ,Bank_Info__r.Average_of_Deposits__c
             ,Ending_Balance__c
             ,Deposits__c
             ,Negative_Days__c
             ,NSF_OD__c
             ,Unusual_Deposits_Amount__c
             ,Average_Daily_Bank_Balance__c
             ,(SELECT Id, Name, Amount__c, Day__c FROM Bank_Statement_Transactions__r ORDER BY Day__c)
             FROM Bank_Statement__c 
             WHERE Bank_Info__c = :bankInfo.Id
             ORDER BY Date__c DESC];
        
        List <Bank_Statement_Transaction__c> transactions = [SELECT Id, Name, Amount__c, Day__c FROM Bank_Statement_Transaction__c ORDER BY Day__c];
        
        TC_ScoringMatrixBankInfoCtrl.saveBankSatements (bankStatements, bankInfo.Id, transactions);
        TC_ScoringMatrixBankInfoCtrl.addBankStatement (bankInfo.Id, '2015', '12');
        Test.stopTest();
    }
}