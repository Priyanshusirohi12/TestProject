public class NT_RelationshipTriggerHelperV4 {
    Public static void RelationshipRollup (List<Relationship__c > rels){
        
        Set<Id> lmIds = new Set<Id>();
        List<LenderMatrix__Lender_Criteria__c> lmsToUpdate = new List<LenderMatrix__Lender_Criteria__c>();
        
        for(Relationship__c rel :rels) {
            lmIds.add(rel.Related_Opportunity__c);
        }       
        
        lmIds.remove(null);
        List <AggregateResult> ar = [SELECT Related_Opportunity__r.LenderMatrix__Lender_Criteria__c lmId, MAX(Related_Opportunity__r.Total_Finance_Amount__c) TFA, MAX(Credit_Score__c ) maxScore, MIN(Bankruptcy__c) bankruptcy, MAX(Open_Tradelines__c)Trade_Lines, MAX(Time_In_Business__c) Time_In_Business,  MAX(Contains_California__c) Contains_California
                                     FROM Relationship__c
                                     WHERE Related_Opportunity__c  IN :lmIds
                                     GROUP BY Related_Opportunity__r.LenderMatrix__Lender_Criteria__c];
        
        
        for(AggregateResult a : ar) { 
            lmsToUpdate.add(new LenderMatrix__Lender_Criteria__c(
                
                Id = ((Id)a.get('lmId')),
                LenderMatrix__FICO__c  = a.get('maxScore') == null ? 0 : (Decimal)a.get('maxScore'),
                Bankruptcy__c =  a.get('bankruptcy') == null ? 0 : (Decimal)a.get('bankruptcy'),
                Trade_Lines__c = a.get('Trade_Lines') == null ? 0 : (Decimal)a.get('Trade_Lines'),
              //  Comp_Credit__c = a.get('Comp_Debt') == null ? 0 : (Decimal)a.get('Comp_Debt')/(a.get('TFA') == 0 ? 1 : (Decimal)a.get('TFA')),
              //  Time_In_Business__c = a.get('Time_In_Business') == null ? 0 : (Decimal)a.get('Time_In_Business'),
                Does_California__c = a.get('Contains_California') == null ? 0 : (Decimal)a.get('Contains_California')
               // Owns_Home__c = a.get('Home_Owner') == null ? 0 : (Decimal)a.get('Home_Owner')                                         
                
                
            ));
            
        } 
        update lmsToUpdate;
    }
}