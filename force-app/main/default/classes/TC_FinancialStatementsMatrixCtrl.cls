public with sharing class TC_FinancialStatementsMatrixCtrl {
   
    @AuraEnabled
    public static List <Financial_Statement__c> initStatements (String accountId) {
        System.debug ('initStatements trying - ' + accountId);
        if (String.isEmpty(accountId)) throw new AuraHandledException ('Account id cannot be null');
        
        try {
            List <Financial_Statement__c> financialStatements = retrieveStatementsForAccount (accountId);
            
            if (financialStatements.isEmpty()) {
                //try populating and retrieving again
                populateStatementsData (accountId);
                financialStatements = retrieveStatementsForAccount (accountId);
            }
            
            return financialStatements;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    @AuraEnabled
    public static List <Financial_Statement__c> saveFinancialStatements (List <Financial_Statement__c> financialStatements, String accountId) {
        try {
            update financialStatements[0].Account__r;
            update financialStatements;
            return initStatements (accountId);
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    @AuraEnabled
    public static List <Financial_Statement__c> addFinancialStatement (List <Financial_Statement__c> financialStatements, String accountId) {
        try {
            update financialStatements;
            Financial_Statement__c fs = new Financial_Statement__c ();
            fs.Account__c = accountId;
            insert fs;
            return initStatements (accountId);
        } catch (DMLException ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    @AuraEnabled
    public static Date validateDate (String value) {
        try {
            return Date.parse (value);
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    private static List <Financial_Statement__c> retrieveStatementsForAccount (String accountId) {
        return new List <Financial_Statement__c> ([SELECT Id
                                                   ,Account__r.Name
                                                   ,Type__c
                                                   ,Quality__c
                                                   ,Fiscal_Year_Ended__c
                                                   ,Cash__c
                                                   ,Current_Assets__c
                                                   ,Total_Assets__c
                                                   ,Current_Liabilities__c
                                                   ,Total_Liabilities__c
                                                   ,Retained_Earnings__c
                                                   ,Net_Worth__c
                                                   ,Tangible_Net_Worth__c
                                                   ,Total_LT_Term_Debt__c
                                                   ,CPLTD_w_o_Revolver__c
                                                   ,CPLTD_w_Revolver__c
                                                   ,Revenue__c
                                                   ,Gross_Profit__c
                                                   ,Net_Income__c
                                                   ,Taxes__c
                                                   ,Interest_Expense__c
                                                   ,Depreciation_Amort__c
                                                   ,EBITDA_Calculated__c
                                                   ,Extraordinary_Gain__c
                                                   ,Extraordinary_Loss__c
                                                   ,Adjusted_Net_Income__c
                                                   ,Debt_Service_Coverage__c
                                                   ,Fixed_Charge_Coverage__c
                                                   ,Current_Ratio__c
                                                   ,Debt_TNW_Leverage__c
                                                   ,Account__r.FS_Type_Comments__c
                                                   ,Account__r.FS_Quality_Comments__c
                                                   ,Account__r.FS_Fiscal_Year_Ended_Comments__c
                                                   ,Account__r.FS_Cash_Comments__c
                                                   ,Account__r.FS_Current_Assets_Comments__c
                                                   ,Account__r.FS_Total_Assets_Comments__c
                                                   ,Account__r.FS_Current_Liabilities_Comments__c
                                                   ,Account__r.FS_Total_Liabilities_Comments__c
                                                   ,Account__r.FS_Retained_Earnings_Comments__c
                                                   ,Account__r.FS_Net_Worth_Comments__c
                                                   ,Account__r.FS_Tangible_Net_Worth_Comments__c
                                                   ,Account__r.FS_Total_LT_Term_Debt_Comments__c
                                                   ,Account__r.FS_CPLTD_w_o_Revolver_Comments__c
                                                   ,Account__r.FS_CPLTD_w_Revolver_Comments__c
                                                   ,Account__r.FS_Revenue_Comments__c
                                                   ,Account__r.FS_Gross_Profit_Comments__c
                                                   ,Account__r.FS_Net_Income_Comments__c
                                                   ,Account__r.FS_Taxes_Comments__c
                                                   ,Account__r.FS_Interest_Expense_Comments__c
                                                   ,Account__r.FS_Depreciation_Amort_Comments__c
                                                   ,Account__r.FS_EBITDA_Comments__c
                                                   ,Account__r.FS_Extraordinary_Gain_Comments__c
                                                   ,Account__r.FS_Extraordinary_Loss_Comments__c
                                                   ,Account__r.FS_Adjusted_Net_Income_Comments__c
                                                   ,Account__r.FS_Debt_Service_Coverage_Comments__c
                                                   ,Account__r.FS_Fixed_Charge_Coverage_Comments__c
                                                   ,Account__r.FS_Current_Ratio_Comments__c
                                                   ,Account__r.FS_Debt_TNW_Leverage_Comments__c
                                              FROM Financial_Statement__c 
                                              WHERE Account__c = :accountId
                                              ORDER BY CreatedDate ASC]);
    }
    
    private static void populateStatementsData (String accountId) {
        List <Financial_Statement__c> financialStatements = new List <Financial_Statement__c> ();
        Financial_Statement__c fs = new Financial_Statement__c ();
        fs.Account__c = accountId;
        financialStatements.add(fs);
        
        //insert statements
        insert financialStatements;
    }
}