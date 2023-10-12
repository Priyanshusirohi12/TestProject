global  class AccountBatchClass implements Database.Batchable<String>,Database.Stateful {
    List<Account> accountList;
    Integer i=0;
    
    global String[] start(Database.BatchableContext BC){  
        return new String[] {'Account'};
    }
    global void execute(Database.BatchableContext BC, String[] scope) {
        String Name = scope.get(0);
        accountList = new List<Account>();
        
      for(Integer count=0;count<5;count++){
            accountList.add( new Account(Name =Name + i, Email__c ='account'+i+'@gmail.com'));
          i++;
        }  
    insert accountList;
  }
    global void finish(Database.BatchableContext BC){
        System.debug('finish account Insert');
        List<Id> accountId = new List<Id>();
        for(Account account : accountList){
            accountId.add(account.Id);
         }
        System.debug('fdfd'+accountId);
        ContactBatchClass contactBatchClass = new ContactBatchClass();
        contactBatchClass.accountId = accountId;
        System.debug(contactBatchClass.accountId+' fdd');
		Database.executeBatch(contactBatchClass,2);
    }
    
}