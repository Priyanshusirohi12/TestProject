/*global class AccountBatchClass implements Database.Batchable<SObject> {
    Integer i=1;
    global Database.QueryLocator start(DataBase.BatchableContext Bc){
        return Database.getQueryLocator([Select Id, AnnualRevenue,Name,Rating,AccountNumber,Phone,Email__C from Account]);
    }
    global void execute(Database.BatchableContext Bc, List<Account> dataList){
        
    }
    global void finish(Database.BatchableContext Bc){
        
    }
}*/
/*global class AccountBatchClass implements Database.Batchable<SObject> {
    Integer i=1;
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id, AnnualRevenue,Name,Rating,AccountNumber,Phone,Email__C from Account]);
    } 
    global void execute(Database.BatchableContext bc, List<Account> dataList){
        
    }
    global void finish(Database.BatchAbleContext bc){
        
    }
}*/
global class  UpdateAccountBatch implements Database.Batchable<SObject>,Database.Stateful {
     Integer i = 1;
    global Database.QueryLocator start(Database.BatchableContext bc){
       return Database.getQueryLocator([Select Id, AnnualRevenue,Name,Rating,AccountNumber,Phone,Email__C from Account]);
    }
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        for(Account account : accountList){
            account.AnnualRevenue = 1500.0;
            account.Email__c  = 'Batch'+i+'@gmail.com';
            i++;
        }
        update accountList;
    }
    
        
    global void finish(Database.BatchableContext BC){
        //system.scheduleBatch(batchable, jobName, minutesFromNow, scopeSize)
        //system.scheduleBatch(batchable, jobName, minutesFromNow)
        System.debug('Batch is finished');
        AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors , JobItemsProcessed,
      TotalJobItems from AsyncApexJob Where Id =: BC.getJobId()];
        Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
        singleEmailMessage.setToAddresses(new List<String>{'Priyanshusirohi12@gmail.com'});
        singleEmailMessage.setSubject('Batch is executed');
        singleEmailMessage.setHtmlBody(' <html> <head><title>Email template</title> </head> <body> <table  border="2px" align="center" width="350px"> <tr> <th>Batch Name</th> <td>UpdateAccountBatch</td> </tr> <tr> <th>Batch Status</th> <td>'+apexJob.Status+'</td> </tr> <tr> <th>Total Batches</th> <td>'+apexJob.TotalJobItems+'</td> </tr> <tr> <th>Batch Process</th> <td>'+apexJob.JobItemsProcessed+'</td> </tr> <tr> <th>Batch Fail</th> <td>'+apexJob.NumberOfErrors+'</td> </tr> </table> </body> </html>');
      	//singleEmailMessage.setHtmlBody('');
        List <Messaging.Email> email = new List<Messaging.Email>{singleEmailMessage};
        Messaging.SendEmailResult [] result = Messaging.SendEmail(email);
        if(result[0].success){
            System.debug('Email is sucessfully Send');
        }else{
            System.debug('Error in Sending'+result[0].errors[0].message);
        }
            
        
    }
}