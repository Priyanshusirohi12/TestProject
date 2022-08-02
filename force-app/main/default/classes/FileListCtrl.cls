public without sharing class FileListCtrl {
    
    @AuraEnabled
    public static List <Account> getAccounts () {
        return [SELECT Id, Name FROM Account];
    }
    
    @AuraEnabled
    public static String getOppIdWithAppNum (String appNum) {
        String oppId = '';
        
        List <Opportunity> opps = new List <Opportunity> ([
        SELECT Id 
        FROM Opportunity 
        //WHERE App__c = :appNum
        ]);
        if (!opps.isEmpty ()) {
            oppId = opps[0].Id;
        }
        
        return oppId;
    }
    
    @AuraEnabled
    public static List <AttachedContentDocument> getFilesWithAppNum (String appNum) {
        List <AttachedContentDocument> files = new List <AttachedContentDocument> ();
        
        List <Opportunity> opps = new List <Opportunity> ([
        SELECT Id, (Select Id, ContentDocumentId, Title FROM AttachedContentDocuments) 
        FROM Opportunity 
        //WHERE App__c = :appNum
        ]);
        
        for (Opportunity opp : opps) {
            if (!opp.AttachedContentDocuments.isEmpty ()) {
                for (AttachedContentDocument file : opp.AttachedContentDocuments) {
                    files.add (file);
                }
            }
        }
        
        return files;
    }
    
    @AuraEnabled
    public static List <Content_Distribution_Wrapper__c> getPublicFilesAppNum (String appNum) {
        
        List <Content_Distribution_Wrapper__c> files = new List <Content_Distribution_Wrapper__c> ();
        
        if (!String.isBlank (appNum)) {
            List <Opportunity> opps = new List <Opportunity> ([
            SELECT Id, (Select Id, Name, URL__c, Size_MB__c FROM Content_Distribution_Wrappers__r) 
            FROM Opportunity 
            //WHERE App__c = :appNum
            ]);
    
            for (Opportunity opp : opps) {
                if (!opp.Content_Distribution_Wrappers__r.isEmpty ()) {
                    for (Content_Distribution_Wrapper__c file : opp.Content_Distribution_Wrappers__r) {
                        files.add (file);
                    }
                }
            }
        }
        
        return files;
    }
    
   
    
}