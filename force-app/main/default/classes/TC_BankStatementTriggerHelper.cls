public with sharing class TC_BankStatementTriggerHelper {

   
    public static void afterInsert (List <Bank_Statement__c> newList) {
        populateTransactionsDays (newList);
    }
    
    public static void beforeInsert (List <Bank_Statement__c> newList) {
        processNewStatements (newList);
    }
    
    private static void processNewStatements (List <Bank_Statement__c> newList) {
        
        for (Bank_Statement__c bs: newList) {
            bs.Date__c = bs.Date__c == null ? System.today() : bs.Date__c;
            
            Datetime dt = Datetime.newInstance (bs.Date__c.year(), bs.Date__c.month(), bs.Date__c.day());
            bs.Name = dt.format('MMM-yy');
        }
    }
    
    
    //create days for transactions when new statement is inserted.
    private static void populateTransactionsDays (List <Bank_Statement__c> newList) {
        
        List <Bank_Statement_Transaction__c> trList = new List <Bank_Statement_Transaction__c> ();
        
        for (Bank_Statement__c bs: newList) {
            //add transaction days
            Date startDate = bs.Date__c == null ? System.today() : bs.Date__c;
            Integer daysInMonth = Date.daysInMonth(startDate.year(), startDate.month());
            
            
            for (Integer i=1; i<=daysInMonth; i++) {
                Bank_Statement_Transaction__c tr = new Bank_Statement_Transaction__c  ();
                tr.Bank_Statement__c = bs.Id;
                tr.Day__c = i;
                trList.add(tr);   
            }
        } 
        
        insert trList;
    }
}