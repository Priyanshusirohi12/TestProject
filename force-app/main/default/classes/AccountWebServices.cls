@RestResource(UrlMapping='/Accountes/*')
global class AccountWebServices {

    @HttpGet
    global static List<Account> getAcountsRecords() {
        return [select id, Name from Account limit 10];
    }
    
   /* 
    @HttpPost
    global static void createAccount(List<String> accObj) {
        System.debug('accObj ' + accObj);
        Account accRec = new Account(
        	Name = name,
            AccountNumber = accountNumber);
       	INSERT accRec;
        return accRec.Id;
        //if() {}
        //return [select id, Name from Account limit 10];
    }*/
    
    @HttpPost
    global static void createChats(String name) {
        System.debug('Coming in this method' + name);
        MessengerChat__c obj = new MessengerChat__c (Name = name);
        INSERT obj;
    }
    
}