global class ContactBatchClass implements Database.Batchable<SObject>, Database.Stateful{
    Integer i =0;
 	global List<Id> accountId = new List<Id>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('hyeeee '+accountId);
        return Database.getQueryLocator([Select Id, Name ,Email__c from Account where id =: accountId]);
    }
    global void execute(Database.BatchableContext BC, List<Account> dataList){
        String name = 'Contact';
        
        List<Contact> contactList= new List<Contact>();
        for(Integer count=0;count<5;count++){
            contactList.add(new Contact(FirstName = name +i, LastName = ' value', AccountId = accountId.get(count)));
            i++;
            if(count ==1){
              break;
          }
        }
        insert contactList;
    }
    global void finish(Database.BatchableContext BC){
        System.debug('contact is execute');
    }
}