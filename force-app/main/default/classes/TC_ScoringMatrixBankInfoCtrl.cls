public with sharing class TC_ScoringMatrixBankInfoCtrl {
    
    @AuraEnabled
    public static List <Bank_Statement__c> initStatements (String bankInfoId) {
        System.debug ('initStatements trying - ' + bankInfoId);
        if (String.isEmpty(bankInfoId)) throw new AuraHandledException ('Bank Info id cannot be null');
        
        
        try {
            List <Bank_Statement__c> bankStatements = retrieveStatementsForBankInfo (bankInfoId);
            
            if (bankStatements.isEmpty()) {
                //try populating and retrieving again
                populateStatemensData (bankInfoId);
                bankStatements = retrieveStatementsForBankInfo (bankInfoId);
            }
            
            return bankStatements;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    @AuraEnabled
    public static List <Bank_Statement__c> saveBankSatements (List <Bank_Statement__c> bankStatements, String bankInfoId, List <Bank_Statement_Transaction__c> transactions) {
        try {
            
            update bankStatements;
            update transactions;
            updateBankInfo (bankStatements);
            return initStatements (bankInfoId);
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
        
    }
    
    @AuraEnabled
    public static List <Bank_Statement__c> addBankStatement (String bankInfoId, String statementYear, String statementMonth) {
        try {
            
            //get latest statement to determine date
            List <Bank_Statement__c> currentStatements = new List <Bank_Statement__c> ([SELECT Id, Date__c 
                                                                                        FROM Bank_Statement__c 
                                                                                        WHERE Bank_Info__c =:bankInfoId ORDER BY Date__c ASC LIMIT 1]);
            
            Date startDate = Date.newInstance (Integer.valueOf(statementYear),Integer.valueOf(statementMonth), 1);
            
            if (startDate > System.today())
                throw new AuraHandledException ('You cannot add statements for the future date. ');
            
            Bank_Statement__c bs = new Bank_Statement__c ();
            bs.Bank_Info__c = bankInfoId;
            bs.Date__c = startDate;
            insert bs;
            return initStatements (bankInfoId);
        } catch (DMLException ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
        
    }
    
    private static void updateBankInfo (List <Bank_Statement__c> bankStatements) {
        Bank_Info__c bankInfo = bankStatements[0].Bank_Info__r;
        integer counter = 0;
        double negDaysLast3Months = 0;
        double nsfODLast3Months = 0;
        List <double> depositsList = new List <double>();
        double deposits = 0;
        double avgNumOfDeposits = [SELECT Average_of_Deposits__c
                                   FROM Bank_Info__c 
                                   WHERE Id = :bankInfo.Id].Average_of_Deposits__c;
        double depositCount = 0;
        double stdDevSum = 0;
        double numDepositCount = -1;
    
        for (Bank_Statement__c bankStatement : bankStatements) {
            if (counter < 3) {
                if (bankStatement.Negative_Days__c != null)
                    negDaysLast3Months = negDaysLast3Months + bankStatement.Negative_Days__c;
                
                if (bankStatement.NSF_OD__c != null)
                    nsfODLast3Months = nsfODLast3Months + bankStatement.NSF_OD__c;
            }
            
            deposits = bankStatement.Deposits__c;
            
            if (deposits != null)
                depositsList.add (deposits);
            
            depositCount = bankStatement.Deposit_Count__c;
            
            if (depositCount != null && avgNumOfDeposits != null) {
                depositCount = avgNumOfDeposits - depositCount;
                depositCount = depositCount * depositCount;
                stdDevSum = stdDevSum + depositCount;
                numDepositCount++;
                
            }
            
            counter++;
        }
        
        depositsList.sort();
        integer depositsSize = depositsList.size();
        
        bankInfo.Neg_Days_Last_3_Months__c = negDaysLast3Months;
        bankInfo.NSF_OD_Last_3_Months__c = nsfODLast3Months;
        
        if (depositsSize == 1) {
            bankInfo.X2nd_Highest__c = depositsList[0];
            bankInfo.X2nd_Lowest__c = depositsList[0];
        }
        else if (depositsSize > 1) {
            bankInfo.X2nd_Highest__c = depositsList[depositsSize - 2];
            bankInfo.X2nd_Lowest__c = depositsList[1];
        }
        
        if (numDepositCount == 0)
            bankInfo.Average_of_Deposits_Stdev__c = null;
        else
            bankInfo.Average_of_Deposits_Stdev__c = Math.sqrt (stdDevSum/numDepositCount);
       
        update bankInfo;
    }
    
    private static List <Bank_Statement__c> retrieveStatementsForBankInfo (String bankInfoId) {
        return new List <Bank_Statement__c> ([SELECT Id
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
                                              ,Bank_Info__r.Average_of_Deposits_Stdev__c
                                              ,Ending_Balance__c
                                              ,Deposits__c
                                              ,Negative_Days__c
                                              ,NSF_OD__c
                                              ,Unusual_Deposits_Amount__c
                                              ,Average_Daily_Bank_Balance__c
                                              ,(SELECT Id, Name, Amount__c, Day__c FROM Bank_Statement_Transactions__r ORDER BY Day__c)
                                              FROM Bank_Statement__c 
                                              WHERE Bank_Info__c = :bankInfoId
                                              ORDER BY Date__c DESC]);
    }
    
    private static void populateStatemensData (String bankInfoId) {
        List <Bank_Statement__c> bankStatements = new List <Bank_Statement__c> ();
       
        
        Date endDate = System.today().toStartOfMonth(); 
        //move 6 months back
        Date startDate = endDate.addMonths(-3);
        
        System.debug(LoggingLevel.INFO, 'startDate = ' + startDate);
        System.debug(LoggingLevel.INFO, 'endDate = ' + endDate);
        
        
        while (startDate<endDate) {
            System.debug(LoggingLevel.INFO, 'startDate = ' + startDate);
            
            Bank_Statement__c bs = new Bank_Statement__c ();
            bs.Bank_Info__c = bankInfoId;
            bs.Date__c = startDate;
            bankStatements.add(bs);
            
            //transactions are added via trigger
            
            //switch to next month
            startDate = startDate.addMonths(1);
        } 
        
        //insert statements
        insert bankStatements;
    
    }
}