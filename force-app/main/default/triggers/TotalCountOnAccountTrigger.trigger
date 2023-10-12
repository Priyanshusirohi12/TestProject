trigger TotalCountOnAccountTrigger on Account (before insert, before update) {
	Integer totalHot=0;
    Integer totalCold=0;
    Integer totalWarm=0; 
    Map<Id,Account> oldAccountMap =Trigger.oldMap;  
    List<Account> accountList =[Select Id, Name, Rating, Total_Hot__c,Total_Cold__c,Total_Warm__c from Account];
    for(Account accountObj : accountList){
            if(accountObj.Rating == 'Hot'){
                totalHot++;
            }else if(accountObj.Rating == 'Warm'){
                totalWarm++;
            }
            else if(accountObj.Rating == 'Cold'){
                totalCold++;
            }
        }
    System.debug(' '+totalHot+' '+totalWarm+' '+totalCold);
    if(Trigger.isInsert){	
    	for(Account accountObj : Trigger.new){
            if(accountObj.Rating == 'Hot'){
                totalHot++;
            }else if(accountObj.Rating == 'Warm'){
                totalWarm++;
            }
            else if(accountObj.Rating == 'Cold'){
                totalCold++;
            }
           accountObj.Total_Hot__c= totalHot;   
           accountObj.Total_Warm__c= totalWarm; 
           accountObj.Total_Cold__c= totalCold; 
            System.debug(''+ accountObj.Total_Hot__c+' '+accountObj.Total_Warm__c+' '+accountObj.Total_Cold__c);
        }
        }     
        if(Trigger.isUpdate){
            for(Account accountObj : Trigger.new){
                System.debug('1233 '+accountObj.Id);
                Account account = oldAccountMap.get(accountObj.Id);
                System.debug('1233 '+account.Rating);
            	if(account.Rating != accountObj.Rating){
                        if(account.Rating=='Hot'){
                            totalHot--;
                        }else if(account.Rating=='Warm'){
                            totalWarm--;
                        }else if(account.Rating=='Cold'){
                            totalCold--;
                        }
                    if(accountObj.Rating=='Hot'){
                        totalHot++;
                    }else if(accountObj.Rating=='Warm'){
                        totalWarm++;
                    }else if(accountObj.Rating=='Cold'){
                        totalCold++;
                    }
                }
                	accountObj.Total_Hot__c= totalHot;   
           			accountObj.Total_Warm__c= totalWarm; 
           			accountObj.Total_Cold__c= totalCold;
        	}
        }
}