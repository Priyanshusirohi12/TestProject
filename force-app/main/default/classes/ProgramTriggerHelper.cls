/*
	Created by : Syed Mehdi
	Created Date : Feb-03-2023
	
	Updated by : Syed Mehdi
	Created Date : Feb-06-2023

*/
public class ProgramTriggerHelper {
    
    public static void showCustomValidationOnUpdate(List<Program__c> programList, Map<Id, Program__c> programOldMap){
        Map<String, Integer> accountRecordTypeMap = new Map<String, Integer>();
        Map<String, String> accountProgramListMap = new Map<String, String>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Account> accountMapToUpdate = new Map<Id, Account>();
        for(Program__c program : programList){
            if(program.RecordTypeId != null && program.Account__c != null && program.RecordTypeId != programOldMap.get(program.Id).RecordTypeId){
                accountIds.add(program.Account__c);
                String accountRecordTypeId = program.Account__c+'-'+program.RecordTypeId;
                if(accountRecordTypeMap.containsKey(accountRecordTypeId)){
                    program.addError('Record type is already Exist');      
                }else {
                    String accountId = accountRecordTypeId.split('-')[0];
                    String recordTypeId = accountRecordTypeId.split('-')[1];
                    String recordTypeNames = Schema.getGlobalDescribe().get('Program__c').getDescribe().getRecordTypeInfosById().get(program.recordTypeId).getName();
                    if(!accountProgramListMap.containsKey(accountId)){
                        accountProgramListMap.put(accountId, recordTypeNames);
                    }else{  
                         accountProgramListMap.put(accountId, accountProgramListMap.get(accountId)+';'+recordTypeNames);
                    }
                    accountRecordTypeMap.put(accountRecordTypeId, 1);
                }     
            } 
        }
        for(Program__c program : programOldMap.values()){
            if(program.Account__c != null){
            	accountIds.add(program.Account__c);    
            }
            
        }
        Map<Id,Account> accountMap = new Map<id, Account>([SELECT  Id, Programs_List__c
                                                           FROM Account
                                                           WHERE Id in : accountIds]);
        for(Program__c program : programList){ 
            if(program.RecordTypeId != null && program.Account__c != null && program.RecordTypeId != programOldMap.get(program.Id).RecordTypeId){
            	String programListRecordtype = accountMap.get(program.Account__c).Programs_List__c;
                Program__c oldProgramRecord = programOldMap.get(program.Id);
                
                if(accountMap.containsKey(program.Account__c) && programListRecordtype != null && programListRecordtype.contains(program.RecordType_Name__c)){
                	program.addError('Record type is already Exist');
            	}    
                else if(accountMap.containsKey(program.Account__c) 
                        && (programListRecordtype == null || !programListRecordtype.contains(program.RecordType_Name__c))){
                	String programRecordTypeList; 
                    if(programListRecordtype != null){
                    	programRecordTypeList = programListRecordtype+';'+accountProgramListMap.get(program.Account__c);
                    }else{
                        programRecordTypeList = accountProgramListMap.get(program.Account__c); 
                    }
                    accountMapToUpdate.put(program.Account__c,(new Account(Id = program.Account__c, Programs_List__c = programRecordTypeList)));
               }
               if(oldProgramRecord.Account__c != null && oldProgramRecord.RecordTypeId != null && 
                  accountMap.containsKey(oldProgramRecord.Account__c) && 
                  accountMap.get(oldProgramRecord.Account__c).Programs_List__c != null &&
                  !accountMap.get(oldProgramRecord.Account__c).Programs_List__c.contains(oldProgramRecord.RecordType_Name__c)){
                	String programRecordTypeList =  programListRecordtype.replace(oldProgramRecord.RecordType_Name__c, '');
                   if(accountMapToUpdate.containskey(oldProgramRecord.Account__c)){
                       accountMapToUpdate.get(oldProgramRecord.Account__c).Programs_List__c = programRecordTypeList;
                   }else{
                       accountMapToUpdate.put(program.Account__c,(new Account(Id = program.Account__c, Programs_List__c = programRecordTypeList)));
                   }	    
               }
            }
        }
        if(accountMapToUpdate.values().size() > 0 ){
            update accountMapToUpdate.values();
        }
    }
    
    public static void updateProgramsListOnDelete(List <Program__c> oldProgramList){
       
        Map<String, String> accountRecordTypeMap = new Map<String, String>();
        List<Account> updateAccount = new List<Account>();
        
        for(Program__c programObj : oldProgramList){
            
            if(programObj.RecordTypeId != null  && programObj.Account__c != null){
                accountRecordTypeMap.put(programObj.Account__c, programObj.RecordType_Name__c);
            }
        }
        for(Account account : [Select id, Programs_List__c From Account Where Id in : accountRecordTypeMap.keySet()]){
            String recordTypeName = accountRecordTypeMap.get(account.Id);
            recordTypeName += account.Programs_List__c.contains(';') ? ';' : '';
            account.Programs_List__c = account.Programs_List__c.Remove(recordTypeName);
            updateAccount.add(account);
        }
        if(updateAccount.size() > 0 ){
        	update updateAccount;    
        }
        
    }
    
	public static void validationAndSetProgramListOnInsert(List<Program__c> programList){
        Map<String, Integer> accountRecordTypeMap = new Map<String, Integer>();
        Map<String, String> accountProgramListMap = new Map<String, String>();
        List<Account> accountListToUpdate = new List<Account>();
        Set<Id> accountIds = new Set<Id>();
        for(Program__c program : programList){
            if(program.RecordTypeId != null && program.Account__c != null){
                accountIds.add(program.Account__c);
                String accountRecordTypeId = program.Account__c+'-'+program.RecordTypeId;
                if(accountRecordTypeMap.containsKey(accountRecordTypeId)){
                    program.addError('Record type is already Exist');      
                }else {
                    String accountId = accountRecordTypeId.split('-')[0];
                    String recordTypeId = accountRecordTypeId.split('-')[1];
                    String recordTypeNames = Schema.getGlobalDescribe().get('Program__c').getDescribe().getRecordTypeInfosById().get(program.recordTypeId).getName();
                    if(!accountProgramListMap.containsKey(accountId)){
                        accountProgramListMap.put(accountId, recordTypeNames);
                    }else{  
                         accountProgramListMap.put(accountId, accountProgramListMap.get(accountId)+';'+recordTypeNames);
                    }
                    accountRecordTypeMap.put(accountRecordTypeId, 1);
                }  
            } 
        }
        Map<Id,Account> accountMap = new Map<id, Account>([SELECT  Id, Programs_List__c
                                                           FROM Account
                                                           WHERE Id in : accountIds]);
        for(Program__c program : programList){
            if(program.RecordTypeId != null && program.Account__c != null){
                String programListRecordtype = accountMap.get(program.Account__c).Programs_List__c;
               
                if(accountMap.containsKey(program.Account__c) && programListRecordtype != null && programListRecordtype.contains(program.RecordType_Name__c)){
                    program.addError('Record type is already Exist');
                }
                else if(accountMap.containsKey(program.Account__c) && (programListRecordtype == null || !programListRecordtype.contains(program.RecordType_Name__c))){
                    String programRecordTypeList; 
                    if(programListRecordtype != null){
                    	programRecordTypeList = programListRecordtype+';'+accountProgramListMap.get(program.Account__c);
                    }else{
                    	programRecordTypeList = accountProgramListMap.get(program.Account__c); 
                    }
                    accountListToUpdate.add(new Account(Id = program.Account__c, Programs_List__c = programRecordTypeList));
                }
            }
        }
        if(accountListToUpdate.size() > 0){
            Update accountListToUpdate;
        }
    }
    
    
    /*------------------------*/
    /*
		This metod is use to calculate the count of brand voc field based upon account and recordType
	*/
    public static Boolean counter = false;
	public static void handlePicklistCount(List<Program__c> programList){	
        Map<String, Map<String,Integer>> brandCountMapBasedOnAccount = new Map<String, Map<String, Integer>>();
        Map<String, Map<String,Integer>> payRateMapBasedOnAccount = new Map<String, Map<String, Integer>>();
        Map<String, Map<String,Integer>> payRateSumMapBasedOnAccount = new Map<String, Map<String, Integer>>();
        Set<Id> accountIds = new Set<Id>(); 
		for(Program__c program : programList){
            if(program.Account__c != null){
				accountIds.add(program.Account__c);
            }
		} 
        System.debug('accountIds '+accountIds);
        for(AggregateResult  product : [SELECT  Account__c, count(Id) brandCount, Brand_VOC__c FROM Program__c 
                                       WHERE RecordType.Name = 'Test Record Type' 
                                       AND	 
                                       Account__c =: accountIds 
                                       Group by Account__c, Brand_VOC__c]){
            Map<String, Integer> brandCountMap = new Map<String, Integer>();
           	System.debug('product 1'+ product);
            String accountId = String.valueOf(product.get('Account__c'));
            String brandVoc = String.valueOf(product.get('Brand_VOC__c'));
            Integer brandCount = Integer.valueOf(product.get('brandCount'));
            if(!brandCountMapBasedOnAccount.containsKey(accountId)){ 
                brandCountMap.put(brandVoc, brandCount);
                brandCountMapBasedOnAccount.put(accountId, brandCountMap);
            }else {
                 brandCountMapBasedOnAccount.get(accountId).put(brandVoc, brandCount);
            }
        }
        
        for(AggregateResult  product : [SELECT  Account__c, count(Id) payRateCount, Sum(Pay_Rate_Amount__c) payRateSum, 
                                       Pay_Rate__c FROM Program__c 
                                       WHERE RecordType.Name = 'Test Record Type' 
                                       AND
                                       Has_Pay_Rate__c = true
                                       AND
                                       Account__c =: accountIds 
                                       Group by Account__c, Pay_Rate__c]){
            Map<String, Integer> payRateCountMap = new Map<String, Integer>();
            Map<String, Integer> payRateSumMap = new Map<String, Integer>();
            System.debug('product '+ product);
            String accountId = String.valueOf(product.get('Account__c'));
            Integer payRateSum = Integer.valueOf(product.get('payRateSum'));
            String payRate = String.valueOf(product.get('Pay_Rate__c'));
            Integer payRateCount = Integer.valueOf(product.get('payRateCount'));
            if(!payRateMapBasedOnAccount.containsKey(accountId)){ 
                payRateCountMap.put(payRate, payRateCount);
                payRateSumMap.put(payRate, payRateSum);
                payRateSumMapBasedOnAccount.put(accountId, payRateSumMap);
                payRateMapBasedOnAccount.put(accountId, payRateCountMap);
                
            }else {
                payRateMapBasedOnAccount.get(accountId).put(payRate, payRateCount);
                payRateSumMapBasedOnAccount.get(accountId).put(payRate, payRateSum);
            }
           	
        }
        List<Program__c> newProgramList = new List<Program__c>();
        for(Program__c programObj : [SELECT Id, Name, Brand_VOC__c, Account__c, BrandVOC_Positive__c,
                                    BrandVOC_Neutral__c, BrandVOC_Negative__c, Pay_Rate__c, Pay_Rate_Amount__c, total_Flat_Rate__c,
                                    total_Gift_Cart__c, Has_Pay_Rate__c, Total_Other_fill_in_text__c FROM Program__c 
                                    WHERE Account__c =: accountIds 
                                    AND
                                    RecordType.Name = 'Test Record Type']){
        	if(brandCountMapBasedOnAccount.containsKey(programObj.Account__c)){
                    if(programObj.Brand_VOC__c != null){
                    programObj.BrandVOC_Neutral__c = brandCountMapBasedOnAccount.get(programObj.Account__c).get('Neutral');
                    programObj.BrandVOC_Positive__c = brandCountMapBasedOnAccount.get(programObj.Account__c).get('Positive');
                    programObj.BrandVOC_Negative__c = brandCountMapBasedOnAccount.get(programObj.Account__c).get('Negative');	
                }
           }
            
            Integer payRateCount = 0;
            Integer payRateSum = 0;
            if(payRateMapBasedOnAccount.containsKey(programObj.Account__c)){
                /*if(payRateMapBasedOnAccount.get(programObj.Account__c).containsKey(programObj.Pay_Rate__c)){
                	payRateCount = payRateMapBasedOnAccount.get(programObj.Account__c).get(programObj.Pay_Rate__c);
                    payRateSum = payRateSumMapBasedOnAccount.get(programObj.Account__c).get(programObj.Pay_Rate__c);
                    programObj.Pay_Rate_Amount__c = payRateSum/payRateCount; 
                }*/
                if(programObj.Pay_Rate__c != null){
                if(programObj.Has_Pay_Rate__c && payRateMapBasedOnAccount.get(programObj.Account__c).containsKey('Flat rate')){
                	payRateCount = payRateMapBasedOnAccount.get(programObj.Account__c).get('Flat rate');
                    payRateSum = payRateSumMapBasedOnAccount.get(programObj.Account__c).get('Flat rate');
                    programObj.total_Flat_Rate__c = payRateSum/payRateCount;  
                }
                if(programObj.Has_Pay_Rate__c && payRateMapBasedOnAccount.get(programObj.Account__c).containsKey('Gift Cart')){
                	payRateCount = payRateMapBasedOnAccount.get(programObj.Account__c).get('Gift Cart');
                    payRateSum = payRateSumMapBasedOnAccount.get(programObj.Account__c).get('Gift Cart');
                    programObj.total_Gift_Cart__c = payRateSum/payRateCount;  
                }
                if(programObj.Has_Pay_Rate__c && payRateMapBasedOnAccount.get(programObj.Account__c).containsKey('Other fill in text')){
                	payRateCount = payRateMapBasedOnAccount.get(programObj.Account__c).get('Other fill in text');
                    payRateSum = payRateSumMapBasedOnAccount.get(programObj.Account__c).get('Other fill in text');
                    programObj.Total_Other_fill_in_text__c = payRateSum/payRateCount;  
                }
                }
            } 
            if((payRateMapBasedOnAccount.containsKey(programObj.Account__c) && programObj.Has_Pay_Rate__c ) || brandCountMapBasedOnAccount.containsKey(programObj.Account__c)){
            	newProgramList.add(programObj);	   
            }
        }
        if(newProgramList.size()>0){
            counter = true;
        	Update newProgramList;
        }
	}
    
    //Add on 30-08-2023
    public static void setSunRiseSunSetDateOnInsert(List <Program__c> programList){
        Set<Id> accountIds = new Set<Id>();
        for(Program__c programObj : programList){
            if( programObj.RecordTypeId != null  && programObj.Account__c != null){
            	 accountIds.add(programObj.Account__c);
            }
        }
        if(!accountIds.isEmpty() && accountIds.size() > 0){
 				List<Account> accountList = fetchAccountRecordsToModify(accountIds, programList, null, 'isInsert');
                if(accountList.size() > 0 ){
                    Update accountList;
                }
        }
	}
    
    
    public static void setSunRiseSunSetDateOnDelete(List <Program__c> oldProgramList){
        Set<Id> accountIds = new Set<Id>();
       //List<Account> accountList = new List<Account>();
        for(Program__c programObj : oldProgramList){
            if(programObj.RecordTypeId != null  && programObj.Account__c != null){
            	 accountIds.add(programObj.Account__c);
            }
        }
        if(!accountIds.isEmpty() && accountIds.size() > 0){
 			List<Account> accountList = fetchAccountRecordsToModify(accountIds, oldProgramList, null, 'isDelete');
            if(accountList.size() > 0 ){
            	System.debug('accountList '+accountList);
                Update accountList;
            }
       	}
	}
    
    
    
   //Add on 30-08-2023
    public static void setSunRiseSunSetDateOnUpdate(List <Program__c> programList, Map<Id, Program__c> oldProgramMap){
        Set<Id> accountIds = new Set<Id>();
        Set<Id> oldaccountIds = new Set<Id>();
        for(Program__c programObj : programList){
            if(programObj.RecordTypeId != null  && programObj.Account__c != null 
               && 
              (programObj.RecordTypeId != oldProgramMap.get(programObj.Id).RecordTypeId)
               || 
              (oldProgramMap.get(programObj.Id).Account__c != programObj.Account__c)
               ||
               (programObj.Sun_Rise_Date__c != oldProgramMap.get(programObj.Id).Sun_Rise_Date__c)
               ||(programObj.Sun_Set_Date__c != oldProgramMap.get(programObj.Id).Sun_Set_Date__c))
                {
            	 accountIds.add(programObj.Account__c);
           	}
            /*if(oldProgramMap.get(programObj.Id).RecordTypeId != '' 
               && oldProgramMap.get(programObj.Id).RecordTypeId != null
               && oldProgramMap.get(programObj.Id).RecordTypeId != programObj.RecordTypeId
               && oldProgramMap.get(programObj.Id).Account__c != programObj.Account__c 
               && oldProgramMap.get(programObj.Id).Account__c != ''
               && oldProgramMap.get(programObj.Id).Account__c != null){
            	oldaccountIds.add(oldProgramMap.get(programObj.Id).Account__c);
        	}*/
        }
        if(!accountIds.isEmpty() && accountIds.size() > 0){
 				List<Account> accountList = fetchAccountRecordsToModify(accountIds, programList, oldProgramMap, 'isUpdate');
                if(accountList.size() > 0 ){
                    Update accountList;
                }
        }
	}
    
    
    
    public static List<Account> fetchAccountRecordsToModify(Set<Id> accountIds, List<Program__c> programList, Map <Id, Program__c> oldProgramMap,  String triggerContext){
        List<Account> accountList = new List<Account>();
        
        Map<Id,Account> accountMap = new Map<id, Account>([SELECT Id, name, Amazon_Influencer_Program_Sunrise_Date__c,
                                                   Amazon_Influencer_Program_Sunset_Date__c, Amazon_Live_Sunrise_Date__c,
                                                   Beauty_Influencer_Program_Sunrise_Date__c, Amazon_Live_Sunset_Date__c,
                                                   Beauty_Influencer_Program_Sunset_Date__c, Fashion_Influencer_Program_Sunrise_Date__c,
                                                   Fashion_Influencer_Program_Sunset_Date__c, FounditonAmazon_Sunrise_Date__c,
                                                   FounditonAmazon_Sunset_Date__c, Home_Influencer_Program_Sunrise_Date__c,
                                                   Home_Influencer_Program_Sunset_Date__c, Young_Customer_Associates_Sunrise_Date__c,
                                                   Young_Customer_Associates_Sunset_Date__c
                                               FROM Account 
                                               WHERE Id in : accountIds]);
            
   		for(Program__c program : programList){
        	if(accountMap.containsKey(program.Account__c)){
                String recordTypeName = Schema.getGlobalDescribe().get('Program__c').getDescribe().getRecordTypeInfosById().get(program.RecordTypeId).getName();
                Account accountrecord = accountMap.get(program.Account__c);
                System.debug('accountrecord '+accountrecord);
                System.debug('program '+program);
                
                System.debug('triggerContext '+triggerContext);
                if(triggerContext == 'isUpdate' || triggerContext == 'isInsert'){
                	accountrecord = setSunriseAndSunsetOnAccount(accountrecord, program, recordTypeName); 
                    System.debug('accountrecord '+accountrecord);
                }
                if(triggerContext == 'isDelete'){
                	accountrecord = setBlankOnSunriseAndSunsetOnAccount(accountrecord, program, recordTypeName); 
                    System.debug('accountrecord '+accountrecord);
                }
                if(triggerContext == 'isUpdate' && accountMap.containsKey(oldProgramMap.get(program.Id).Account__c) && 
                   program.RecordTypeId != oldProgramMap.get(program.Id).recordtypeId &&
                   oldProgramMap.get(program.Id).recordtypeId != null){
                       System.debug('only update');
                    String oldrecordTypeName = Schema.getGlobalDescribe().get('Program__c').getDescribe().getRecordTypeInfosById().get(oldProgramMap.get(program.Id).recordtypeId).getName();
                     accountrecord =  setBlankOnSunriseAndSunsetOnAccount(accountrecord, oldProgramMap.get(program.Id), oldrecordTypeName);
             	}
                
                accountList.add(accountrecord);
            }
    	}
        return accountList;
    }
    public static Account setSunriseAndSunsetOnAccount(Account accountRecord, Program__c program, String RecordTypeName){
        //setSunRiseAndSunSetDateAccountToRecordType(program, accountrecord, recordtypeName);
        	if(RecordTypeName == 'Amazon Influencer Program'){
            	accountRecord.Amazon_Influencer_Program_Sunrise_Date__c = program.Sun_Set_Date__c;
            	accountrecord.Amazon_Influencer_Program_Sunset_Date__c = program.Sun_Rise_Date__c;
            }else if(RecordTypeName == 'Amazon Live'){
            	accountRecord.Amazon_Live_Sunrise_Date__c = program.Sun_Rise_Date__c;
               	accountrecord.Amazon_Live_Sunset_Date__c = program.Sun_Set_Date__c;
           	}else if(RecordTypeName == 'Beauty Influencer Program'){
           		accountRecord.Beauty_Influencer_Program_Sunrise_Date__c = program.Sun_Rise_Date__c;
                accountRecord.Beauty_Influencer_Program_Sunset_Date__c = program.Sun_Set_Date__c;
            }else if(RecordTypeName == 'Fashion Influencer Program'){
                accountRecord.Fashion_Influencer_Program_Sunrise_Date__c = program.Sun_Rise_Date__c;
                accountRecord.Fashion_Influencer_Program_Sunset_Date__c = program.Sun_Set_Date__c;  
            }else if(RecordTypeName == 'FounditonAmazon'){
                accountRecord.FounditonAmazon_Sunrise_Date__c = program.Sun_Rise_Date__c;
                accountRecord.FounditonAmazon_Sunset_Date__c = program.Sun_Set_Date__c;   
           	}else if(RecordTypeName == 'Home Influencer Program'){
                accountRecord.Home_Influencer_Program_Sunrise_Date__c = program.Sun_Rise_Date__c;
                accountRecord.Home_Influencer_Program_Sunset_Date__c = program.Sun_Set_Date__c;  
           	}else if(RecordTypeName == 'Young Customer Associates'){
                accountRecord.Young_Customer_Associates_Sunrise_Date__c = program.Sun_Rise_Date__c;
                accountRecord.Young_Customer_Associates_Sunset_Date__c = program.Sun_Set_Date__c;
           	}else{
                System.debug('Do not save');       
         	}
        return accountRecord;
    }
    
    public static Account setBlankOnSunriseAndSunsetOnAccount(Account accountRecord, Program__c program, String RecordTypeName){
        //setSunRiseAndSunSetDateAccountToRecordType(program, accountrecord, recordtypeName);
        	if(RecordTypeName == 'Amazon Influencer Program'){
            	accountRecord.Amazon_Influencer_Program_Sunrise_Date__c = null;
            	accountrecord.Amazon_Influencer_Program_Sunset_Date__c = null;
            }else if(RecordTypeName == 'Amazon Live'){
            	accountRecord.Amazon_Live_Sunrise_Date__c = null;
               	accountrecord.Amazon_Live_Sunset_Date__c = null;
           	}else if(RecordTypeName == 'Beauty Influencer Program'){
           		accountRecord.Beauty_Influencer_Program_Sunrise_Date__c = null;
                accountRecord.Beauty_Influencer_Program_Sunset_Date__c = null;
            }else if(RecordTypeName == 'Fashion Influencer Program'){
                accountRecord.Fashion_Influencer_Program_Sunrise_Date__c = null;
                accountRecord.Fashion_Influencer_Program_Sunset_Date__c = null;  
            }else if(RecordTypeName == 'FounditonAmazon'){
                accountRecord.FounditonAmazon_Sunrise_Date__c = null;
                accountRecord.FounditonAmazon_Sunset_Date__c = null;   
           	}else if(RecordTypeName == 'Home Influencer Program'){
                accountRecord.Home_Influencer_Program_Sunrise_Date__c = null;
                accountRecord.Home_Influencer_Program_Sunset_Date__c = null;  
           	}else if(RecordTypeName == 'Young Customer Associates'){
                accountRecord.Young_Customer_Associates_Sunrise_Date__c = null;
                accountRecord.Young_Customer_Associates_Sunset_Date__c = null;
           	}else{
                System.debug('Do not save');       
         	}
        return accountRecord;
    }
    
    
    
   
}