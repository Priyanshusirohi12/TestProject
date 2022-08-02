public class TC_EquipmentTriggerHelper {
    
    public static void updateOppEquipDesc (Map <Id, Equipment__c> oldMap, Map <Id, Equipment__c> newMap) {
        
//        Map <Id, Id> equipOppMap = new Map <Id, Id> ();
//
//        // if equipment name/description changed
//
//        for (Equipment__c eq : newMap.values ()) {
//            if (eq.Opportunity__c != null && (oldMap == null || eq.Name != oldMap.get (eq.Id).Name)) {
//                equipOppMap.put (eq.Id, eq.Opportunity__c );
//            }
//        }
//
//        if (!equipOppMap.isEmpty ()) {
//            List <Opportunity> updateList = new List <Opportunity> ();
//
//            for (Opportunity opp : [SELECT Id, Equipment_Description__c, (SELECT Name FROM Opportunity_Assets__r ORDER BY CreatedDate ASC LIMIT 1) FROM Opportunity WHERE Id IN :equipOppMap.values ()]) {
//                if (!opp.Opportunity_Assets__r.isEmpty () && opp.Equipment_Description__c != opp.Opportunity_Assets__r[0].Name) {
//                    updateList.add (new Opportunity (Id = opp.Id, Equipment_Description__c = opp.Opportunity_Assets__r[0].Name));
//                }
//            }
//
//            try {
//                update updateList;
//            } catch (Exception e) {
//                System.debug ('Error updating Equipment Description on Opportunity: ' + e);
//            }
//        }
    }
    
}