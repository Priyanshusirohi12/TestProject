public class NT_EquipmentTriggerHelper {
    Public static void EquipmentRollup (List<Equipment__c> equips){
        
        Set<Id> lmIds = new Set<Id>();
        List<LenderMatrix__Lender_Criteria__c> lmsToUpdate = new List<LenderMatrix__Lender_Criteria__c>();
        
        for(Equipment__c equip :equips) {
            lmIds.add(equip.Opportunity__c);
        }       
        
        lmIds.remove(null);
		List <AggregateResult> ar = [SELECT Opportunity__r.LenderMatrix__Lender_Criteria__c lmId,  MAX(Opportunity__r.Total_Finance_Amount__c) TFA, MIN(Value_of_Year__c ) Oldest_Year, SUM(Cost_Per_Unit__c) Min_Size, MAX(Cost_Per_Unit__c) Max_Size, MIN(Private_Party_Formula__c)Private_Party, MIN(Equipment_Titled__c )Equipment_Titled, MIN(Condition_Formula__c )Condition, MAX(OTR_Formula__c )OTR
                                 FROM Equipment__c 
                                 WHERE Opportunity__c  IN :lmIds
                                 GROUP BY Opportunity__r.LenderMatrix__Lender_Criteria__c];       
        for(AggregateResult a : ar){
                                     
                                     lmsToUpdate.add(new LenderMatrix__Lender_Criteria__c(
                                         Id = (Id)a.get('lmId'),
                                         Oldest_Equipment_Year__c  = a.get('Oldest_Year') == null ? 0 : (Decimal)a.get('Oldest_Year'),
                                         //Min_Size__c =  a.get('Min_Size') == null ? 0 : (Decimal)a.get('Min_Size'),
                                      //   Max_Size__c = a.get('Max_Size') == null ? 0 : (Decimal)a.get('Max_Size'),
                                         Is_Equipment_Titled__c = a.get('Equipment_Titled') == null ? 0 : (Decimal)a.get('Equipment_Titled'),
                                         Private_Party__c = a.get('Private_Party') == null ? 0 : (Decimal)a.get('Private_Party'),
                                         Condition__c = a.get('Condition') == null ? 0 : (Decimal)a.get('Condition')                                         
//                                         OTR__c = a.get('OTR') == null ? 0 : (Decimal)a.get('OTR')
                                     ));
                                     
                                 }
        update lmsToUpdate;
    }
}