public class TC_DealDocumentsUploadCtrl {
    
    @AuraEnabled
    public static List<Opportunity> getOpportunities (String objId) {
        System.debug ('getObject trying - ' + objId);       
        try {
            List<Opportunity> sobj = retrieveOpportunities (objId);
            
            system.debug('Opportunity = ' +sobj);
            
            
            if(sobj.size() == 0){
                throw new AuraHandledException ('Error : Credit Application Not Found');
            }
            
            return sobj;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    @AuraEnabled
    public static List <ContentVersion > getContent (String objId) {
        System.debug ('getContent trying - ' + objId);       
        try {
            List <ContentVersion> contentList = retrieveContent (objId);
            
            system.debug('CONTENT = ' +contentList);
            
            return contentList;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    @AuraEnabled
    public static List <ContentVersion > markDeleteFiles (String objId, List<Id> fileIds) {
        System.debug ('markDeleteFiles trying - ' + fileIds);       
        try {
            
                        
            markFiles (fileIds, TRUE);            
            
            List <ContentVersion> contentList = retrieveContent (objId);
            
            system.debug('CONTENT = ' +contentList);
            
            return contentList;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }  
    
    @AuraEnabled
    public static List <ContentVersion > unmarkDeleteFiles (String objId, List<Id> fileIds) {
        System.debug ('markDeleteFiles trying - ' + fileIds);       
        try {
            
                        
            markFiles (fileIds, FALSE);            
            
            List <ContentVersion> contentList = retrieveContent (objId);
            
            system.debug('CONTENT = ' +contentList);
            
            return contentList;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }     
    
    private static List<Opportunity> retrieveOpportunities (String objId) {
              
        return new List <Opportunity> ([SELECT                                         
                                        Id,
                                        Account.Name,
                                        //App__c,
                                        Name
                                        FROM Opportunity
                                        WHERE Id = :objId  
                                       ]);
    } 
    
    private static List <ContentVersion> retrieveContent (String objId) {
        return new List <ContentVersion> ([SELECT 
                                           Title, 
                                           FileExtension, 
                                           FileType,
                                           Mark_To_Delete__c,
                                           ContentModifiedDate  
                                           FROM 
                                           ContentVersion 
                                           WHERE 
                                           //TC_Origination__Parent_Id__c = :objId  
                                           Document_Source__c = 'Syndication Partner Upload'
                                           ORDER BY ContentModifiedDate DESC]);
    } 
    private static void markFiles (List<Id> fileIds, Boolean mark) {
         List <ContentVersion> fileList = new List <ContentVersion> ([SELECT 
                                           Title, 
                                           FileExtension, 
                                           FileType,
                                           Mark_To_Delete__c,                           
                                           ContentModifiedDate  
                                           FROM 
                                           ContentVersion 
                                           WHERE Id IN :fileIds  
                                           ]);
        for(ContentVersion file : fileList){
            if(file.Mark_To_Delete__c <> mark){
                if(mark == TRUE){
                    file.Title = file.Title + '--DELETE--';
                    file.Mark_To_Delete__c = TRUE;
                }else{
                    file.Title = file.Title.replace('--DELETE--','');
                    file.Mark_To_Delete__c = FALSE;                
                }
            }
        }
        update fileList;
        
    } 
}