public class DisplayAllAccountsController {
	public DisplayAllAccountsController(){

    }
    @AuraEnabled (cacheable=true)
    public static List<Account> getAccountSearchingRecord(String searchkey){
        /*List<Contact> contactList = [SELECT Id,AccountId, Account.Name, Account.Email__c, Account.Phone, Account.Id FROM Contact];
        Integer totalContact = 0 ;
        
        List<Account> accountList = [SELECT Id , Name , Phone, Rating, Email__c, (SELECT Id FROM Contacts)
                FROM Account
               	WHERE Name Like: '%' +searchkey+ '%'];
			List<Map<String,Object>> listOfMap = new List<Map<String,Object>>();
            for (Account account : accountList) {
                Map<String, Object> objectMap= new Map<String, Object>();
            	System.debug('Count of Contacts is ' + account.Contacts.size());
                objectMap.put('Id', account.Id);
                objectMap.put('Name',account.Name);
                objectMap.put('totalContact',account.Contacts.Size());
                objectMap.put('Email__c',account.Email__c);
                objectMap.put('Rating',account.Rating);
                objectMap.put('Phone',account.Phone); 
                System.debug(objectMap);
                listOfMap.add(objectMap);
            }
        	System.debug(listOfMap);*/
        
        return [SELECT Id , Name , Phone, Rating, Email__c, (SELECT Id FROM Contacts)
                FROM Account
               	WHERE Name Like: '%' +searchkey+ '%'];
    }

    @AuraEnabled
    public static void deleteRecord(Id delId){
        Delete [SELECT Id, Name, Phone, Rating, Email__c FROM Account WHERE Id =: delId];
    }

    @AuraEnabled
    public static Account fatchRecord(Id id){
        return [SELECT Id, Name, Phone , Rating, Email__c FROM Account WHERE Id =: id];
    }  
}