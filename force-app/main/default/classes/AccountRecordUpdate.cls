global class AccountRecordUpdate implements Database.Batchable<Sobject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name, rating FROM Account WHERE CreatedDate =: System.today()]);  
    }
    global void execute(Database.BatchableContext bc, List<Account> todaysAccounyList){
        List<account> accountList = new List<Account>();
        for(Account accountObject : todaysAccounyList){
            accountList.add(new Account(Name ='Pradhyumn bansal', rating='Hot'));
        }
        update accountList;
    }
    global void finish(Database.BatchableContext bc){
        System.debug('Account is execute');
    }
}