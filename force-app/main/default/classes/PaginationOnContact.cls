public class PaginationOnContact {
    public List<SetupAuditTrail> AuditTrailList{get;set;}  
    public List<SetupAuditTrail> AuditTrailDispalyList{get;set;}
    public Map<Integer, Set<Id>> aditTrailIdsMap {get;set;}
    public Integer pageNumber {get;set;}
    Set<Id> getFullIdsSet = new Set<Id>();
   
    public List<SetupAuditTrail> getAuditTrailNextList(Set<Id> auditTrailIds){
        String query = 'SELECT Id, Display, Section, CreatedDate, Action FROM SetupAuditTrail';
        if(auditTrailIds != null){
       		query +=  ' WHERE Id NOT IN : auditTrailIds';   
    	}
        query +=  ' Order by CreatedDate Desc LIMIT 5';
        List<SetupAuditTrail> filteredAuditTrailList = new List <SetupAuditTrail>();
        for(SetupAuditTrail auditTrail : Database.query(query)){
            if(auditTrail.Section == 'Apex Class' || auditTrail.Section == 'Page'){
                filteredAuditTrailList.add(auditTrail);
            }
        }
        System.debug('filteredAuditTrailList '+filteredAuditTrailList);
        return filteredAuditTrailList;
    }
    
    public List<SetupAuditTrail> getAuditTrailPreviousList(Set<Id> auditTrailIds){
        List<SetupAuditTrail> filteredAuditTrailList = new List <SetupAuditTrail>();
        for(SetupAuditTrail auditTrail : [SELECT Id, Display, Section, CreatedDate, Action FROM SetupAuditTrail
               WHERE Id IN : auditTrailIds Order By CreatedDate Desc
               LIMIT 5]){
        	if(auditTrail.Section == 'Apex Class' || auditTrail.Section == 'Page'){
                filteredAuditTrailList.add(auditTrail);
        	}         
        }
        return filteredAuditTrailList;
        
    }
    
    
    public PaginationOnContact(){
        aditTrailIdsMap = new Map <Integer, Set<Id>>();
		AuditTrailDispalyList = getAuditTrailNextList(null);
        pageNumber = 1;
        if(AuditTrailDispalyList.size() > 0){
            for(SetupAuditTrail auditTrail : AuditTrailDispalyList){
                if(!aditTrailIdsMap.containsKey(pageNumber)){
                    aditTrailIdsMap.put(pageNumber, new Set<Id>{auditTrail.Id});
                }else if(aditTrailIdsMap.containsKey(pageNumber)){
                    aditTrailIdsMap.get(pageNumber).add(auditTrail.Id);
                }    
            }
        }
    }
    
    public void nextPage(){
        If(aditTrailIdsMap.keySet().size() > 0){
        	for(Integer var : aditTrailIdsMap.Keyset()){
        		getFullIdsSet.addAll(aditTrailIdsMap.get(var)); 
                System.debug('check If ');
        	}    
        } 
        List<SetupAuditTrail> auditTrailList = getAuditTrailNextList(getFullIdsSet);
        System.debug('auditTrailList '+auditTrailList.size());
        if(auditTrailList.size() > 0){
            AuditTrailDispalyList = auditTrailList;
        	pageNumber += 1;
            System.debug('check If er'+pageNumber);
            for(SetupAuditTrail auditTrail : AuditTrailDispalyList){
                System.debug('auditTrail '+auditTrail);
                if(!aditTrailIdsMap.containsKey(pageNumber)){
                    aditTrailIdsMap.put(pageNumber, new Set<Id>{auditTrail.Id});
                }else if(aditTrailIdsMap.containsKey(pageNumber)){
                    aditTrailIdsMap.get(pageNumber).add(auditTrail.Id);
                }
            }
                System.debug('aditTrailIdsMap '+aditTrailIdsMap);
        }else{
            System.debug('NO List Found');
        }
        
    }
    public void previousPage(){
        List<SetupAuditTrail> auditTrailList = getAuditTrailPreviousList(aditTrailIdsMap.get(pageNumber -1));  
        if(auditTrailList.size() > 0){
            AuditTrailDispalyList = auditTrailList;
            aditTrailIdsMap.remove(pageNumber);
        	pageNumber--;    
        }else{
            System.debug('NO List Found');
        }
        
        	
    }    
}