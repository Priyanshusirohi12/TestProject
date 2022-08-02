public class TC_CostOfFundTriggerHelper {
    
	// Custom SMFL logic for using COF and LTS records to calculate COF rate.
    public static void updateCOFInformation() {
        
        List<Cost_of_Fund__c> cofList = new List<Cost_of_Fund__c> ([SELECT Date__c, X12__c,X13_24__c,X25_36__c,X37_48__c
                                                                    ,X49_60__c,X61_72__c,X73_84__c,X85_96__c,X97_108__c
                                                                    ,X109_120__c
                                                                    FROM Cost_of_Fund__c
                                                                    ORDER BY Date__c Desc]);

        if (!cofList.isEmpty()) {
            
            List<Opportunity> oppUpdateList = new List<Opportunity>();
            List<Opportunity> oppList = new List<Opportunity>([
                SELECT Id, COF_Date__c, Term__c, COF__c, COF_Lock__c
                FROM Opportunity
                WHERE Term__c != null AND COF_Lock__c = false]);

            for (Opportunity opp : oppList) {
                
                Integer oppTerm= (Integer) opp.Term__c;
    
                if (oppTerm >= 12 && oppTerm <= 120) {
                    Date oppDate = opp.COF_Date__c;
                    
                    String termAPIName;
                    if (oppTerm == 12) termAPIName = 'X12__c';
                    else if (13 <= oppTerm && oppTerm <= 24) termAPIName = 'X13_24__c';
                    else if (25 <= oppTerm && oppTerm <= 36) termAPIName = 'X25_36__c';
                    else if (37 <= oppTerm && oppTerm <= 48) termAPIName = 'X37_48__c';
                    else if (49 <= oppTerm && oppTerm <= 60) termAPIName = 'X49_60__c';
                    else if (61 <= oppTerm && oppTerm <= 72) termAPIName = 'X61_72__c';
                    else if (73 <= oppTerm && oppTerm <= 84) termAPIName = 'X73_84__c';
                    else if (85 <= oppTerm && oppTerm <= 96) termAPIName = 'X85_96__c';
                    else if (97 <= oppTerm && oppTerm <= 108) termAPIName = 'X97_108__c';
                    else if (109 <= oppTerm && oppTerm <= 120) termAPIName = 'X109_120__c';
                    
                    Decimal newCOFValue = -1.0;
                    if (oppDate == null) {
                        newCOFValue = (Decimal) cofList[0].get(termAPIName);
                    } else {
                        for (Cost_of_Fund__c cof : cofList) {
                            if (cof.Date__c <= oppDate) {
                                newCOFValue = (Decimal) cof.get(termAPIName);
                                break;
                            }
                        }
                    } 
                    if (newCOFValue != -1.0 && opp.COF__c != newCOFValue) {
                        opp.COF__c = newCOFValue;
                        opp.From_CoF_Trigger__c = true;
                        oppUpdateList.add(opp);
                    }
                } else {
                    if (opp.COF__c != null) {
                        opp.COF__c = null;
                        opp.From_CoF_Trigger__c = true;
                        oppUpdateList.add(opp);
                    }
                }

                
            }
            
            update oppUpdateList;

        }

    }

}