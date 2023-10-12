public class SearchableController {
	@AuraEnabled 
    public static List<Sobject> searchContact(String value, String objectName, Id projectId, String owner){
        
        String fields = 'Id, Name ';  
        String filter = ' WHERE Name LIKE \''+ value + '%\' ORDER BY Name';
        if(objectName == 'Sprint__c' && owner == ''){
        	filter = ' WHERE Gantt_Project__c = \''+ projectId +'\' AND Name Like \'' + value + '%\' ORDER BY Name';    
        }else if(owner == 'User' && objectName == 'Sprint__c'){
            objectName = owner;
        }
        String query = 'SELECT '+ fields + ' FROM ' + objectName + ' ' + filter ;
        system.debug('query ' + query);
        return Database.query(query);
        
        /*if(objectName == 'contact'){
        	return [SELECT Id, Name FROM Contact WHERE Name LIKE: + value + '%' ORDER BY Name];
        }else if(objectName =='gantt project'){
        	return [SELECT Id, Name FROM Gantt_Project__c WHERE Name LIKE: + value + '%' ORDER BY Name];
        }else if(objectName == 'sprint' && owner == ''){
            return [SELECT Id, Name FROM Sprint__c WHERE Gantt_Project__c =: projectId AND Name Like : + value + '%' ORDER BY Name];
        }else if(owner == 'owner' && objectName == 'sprint'){
            return [SELECT Id, Name FROM User WHERE Name LIKE : + value + '%' ORDER BY Name];
        }else{
            return null;
        }*/
    }
}