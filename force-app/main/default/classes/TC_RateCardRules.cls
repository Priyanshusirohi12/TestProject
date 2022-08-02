public class TC_RateCardRules {
    
    //@InvocableMethod
    public static List<Decimal> getRate(List<Id> objIds) {
        
        List<Decimal> rates = new List<Decimal>();
        
        rates.add(getRate(objIds[0]));
            
        return rates;
    }
    
    public static Decimal getRate(Id objId){

        TCRE.RuleEngine rateCardRE = new TCRE.RuleEngine();
        
        Set<Id> objIds = new Set<Id>();
        objIds.add(objId);

 
        rateCardRE.logicObjectIds = objIds;
        
        rateCardRE.ruleObjectType = 'RateCard__c';

        rateCardRE.TestRuleConditions();
        
        
        system.debug('-----------------Rate Card Entry Criteria RESULTS--------------');
        
        system.debug(rateCardRE.RuleResults);

        Id firstRateCard;
        for(Map<Id, Boolean> rule : rateCardRE.RuleResults.values()){
            for(Id ruleId : rule.keySet()){
                if(rule.get(ruleId) == TRUE && firstRateCard == null){
                    firstRateCard = ruleId;
                }
            }
        }

        system.debug('first TRUE RateCard ruleId = '  + firstRateCard);

        if(firstRateCard <> null){
            
            TCRE.RuleEngine rateRowRE = new TCRE.RuleEngine();           
            rateRowRE.logicObjectIds = objIds;
            rateRowRE.ruleObjectType = 'Rate_Card_Row__c';
            rateRowRE.TestRuleConditions();
            
            system.debug('-----------------Rate Card Row Criteria RESULTS--------------');           
            system.debug(rateRowRE.RuleResults);     

            
            //find the TRUE row rule
            Set<Id> trueRowIds = new Set<Id>();
            for(Map<Id, Boolean> rule : rateRowRE.RuleResults.values()){
                for(Id ruleId : rule.keySet()){
                    if(rule.get(ruleId) == TRUE){
                        system.debug('TRUE ROW ruleId = '  + ruleId);
                        trueRowIds.add(ruleId);
                    }
                }
            }
                      
            
            TCRE.RuleEngine rateColRE = new TCRE.RuleEngine();           
            rateColRE.logicObjectIds = objIds;
            rateColRE.ruleObjectType = 'Rate_Card_Column__c';
            rateColRE.TestRuleConditions();
            
            system.debug('-----------------Rate Card Column Criteria RESULTS--------------');           
            system.debug(rateColRE.RuleResults);  
            
            
            //find the TRUE column rule
            Set<Id> trueColIds = new Set<Id>();
            for(Map<Id, Boolean> rule : rateColRE.RuleResults.values()){
                for(Id ruleId : rule.keySet()){
                    if(rule.get(ruleId) == TRUE){
                        system.debug('TRUE Col ruleId = '  + ruleId);
                        trueColIds.add(ruleId);
                    }
                }
            }  
            
            
                List<Rate_Card_Rate__c> rates = [
                    SELECT Id, Rate__c
                    FROM Rate_Card_Rate__c
                    WHERE Rate_Card_Row__r.Row_Criteria__c IN :trueRowIds
                    AND Rate_Card_Column__r.Column_Criteria__c IN :trueColIds
                    AND Rate_Card_Row__r.Rate_Card__r.Entry_Criteria__c = :firstRateCard
                    AND Rate_Card_Column__r.Rate_Card__r.Entry_Criteria__c = :firstRateCard

                    
                ];
                
                system.debug('Rates results = ' + rates);
                
                if(rates.size() > 0){
                    system.debug('-------------------- RATE FOUND --------------------------');
                    system.debug('RATE == ' + rates[0].Rate__c);
                    return rates[0].Rate__c;
                }
        }

        return null;
        
    }
}