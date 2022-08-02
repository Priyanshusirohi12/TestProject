public without sharing class FileListHeaderCtrl {
    
    
    @AuraEnabled
    public static String getOpportunityAndAccountName (String appNum) {
        String name = 'No Deals Found';
        List <Opportunity> opp = new List <Opportunity> ([
        SELECT Name, Account.Name 
        FROM Opportunity 
        //WHERE App__c = :appNum
        ]);
        
        if (!opp.isEmpty () && !String.isBlank (appNum)) {
            name = opp[0].Name + ' - ' + opp[0].Account.Name;
        }
        return name;
    }
}