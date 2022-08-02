public class TC_ContactTriggerHelper {

    public static void originatorTieToApp (Map <Id, Contact> oldMap, Map <Id, Contact> newMap) {
    
        Map <Id, Contact> emailChangedMap = new Map <Id, Contact> ();
        
        for (Contact con : newMap.values ()) {
            if (con.Email != null && con.AccountId != null && (oldMap == null || oldMap.get (con.Id).Email != con.Email)) {
                emailChangedMap.put (con.Id, con);
            }
        }
        if (!emailChangedMap.isEmpty ()) {
            TC_OriginatorHelper.tieAppToBrokerAndRep (emailChangedMap);
        }
    }

    public static void updateSSN (Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {

    }
}