public class TC_LikeTermSwapTriggerHelper {
    
    public static void updateLTSInformation(Map<Id, Like_Term_Swap__c> newMap) {
        
        Like_Term_Swap__c ltsRecent = TC_DataUtility.getAllFieldsOnLikeTermSwapLimitMostRecent();
        Set<String> ltsFields = Schema.SObjectType.Like_Term_Swap__c.fields.getMap().keySet();
        
        if (ltsRecent != null && ltsRecent.Id != null && newMap.containsKey(ltsRecent.Id)) {
            
			List<Opportunity> oppUpdateList = new List<Opportunity>();
            List<Opportunity> oppList = new List<Opportunity>([
                SELECT Id, Term__c, LTS__c
                FROM Opportunity
                WHERE Term__c != null]);
            
            for (Opportunity opp : oppList) {
                
                if (opp.Term__c >= 12 && opp.Term__c <= 120) {
                    Decimal ltsValue;
                    String termAPIName = 'x' + String.valueOf(opp.Term__c) + '__c';
                    if (ltsFields.contains(termAPIName)) {
                        ltsValue = (ltsRecent.Id != null) ? (Decimal) ltsRecent.get(termAPIName) : null;
                        if (ltsValue != opp.LTS__c) {
                            opp.LTS__c = ltsValue;
                            oppUpdateList.add(opp);
                        }
                    }
                } else {
                    if (opp.LTS__c != null) {
                        opp.LTS__c = null;
                        oppUpdateList.add(opp);
                    }
                }
               
            }
            
            update oppUpdateList;
            
        }
    }

}