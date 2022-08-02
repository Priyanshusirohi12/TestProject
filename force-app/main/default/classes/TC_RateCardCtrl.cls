public with sharing class TC_RateCardCtrl {
    
    @AuraEnabled
    public static List <Rate_Card_Row__c> getRows (String rateCardId) {
        System.debug ('getRows trying - ' + rateCardId);
        
        
        
        try {
            List <Rate_Card_Row__c> rateCardRows = retrieveRateCardRows (rateCardId);
            
            return rateCardRows;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
    
    
    
    @AuraEnabled
    public static List <Rate_Card_Column__c> getColumns (String rateCardId) {
        System.debug ('getColumns trying - ' + rateCardId);
        
        
        
        try {
            List <Rate_Card_Column__c> rateCardCols = retrieveRateCardCols (rateCardId);
            
            return rateCardCols;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }
 
        
    @AuraEnabled
    public static List<Rate_Card_Column__c> saveRateCardValues (Id rateCardId, List <Rate_Card_Rate__c> rateList) {

        try {

            system.debug('rateCardId = ' + rateCardId);
            system.debug('rateList = ' + rateList);
            
            update rateList;      

            return retrieveRateCardCols(rateCardId);
            
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }

    }
    
    
    
    private static List <Rate_Card_Row__c> retrieveRateCardRows (String rateCardId) {
        return new List <Rate_Card_Row__c> ([SELECT Id
                                             ,Name
                                             ,Order__c
                                             FROM Rate_Card_Row__c 
                                             WHERE Rate_Card__c = :rateCardId
                                             ORDER BY Order__c ASC]);
    }     
    private static List <Rate_Card_Column__c> retrieveRateCardCols (String rateCardId) {
        return new List <Rate_Card_Column__c> ([SELECT Id
                                                ,Name
                                                ,Order__c
                                                ,(
                                                    SELECT Id, Rate__c, Rate_Card_Column__c, Rate_Card_Row__c
                                                    FROM Rate_Card_Rates__r
                                                    ORDER BY Rate_Card_Row__r.Order__c
                                                )
                                                FROM Rate_Card_Column__c
                                                WHERE Rate_Card__c = :rateCardId
                                                ORDER BY Order__c ASC]);
    }   
    
}