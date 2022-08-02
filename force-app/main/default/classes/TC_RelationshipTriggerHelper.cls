public class TC_RelationshipTriggerHelper {
    public static void after (List <Relationship__c> oldList, List <Relationship__c> newList) {
        List <Relationship__c> processList;
        
        if (oldList != null && newList != null) {
            processList = new List <Relationship__c> ();
            Integer i = 0;
            
            for (Relationship__c r : oldList) {
                if (r.Business__c != newList[i].Business__c || r.Person__c != newList[i].Person__c) {
                    processList.add (r);
                    processList.add (newList[i]);
                }
                
                i++;
            }
        }
        else if (oldList != null)
            processList = oldList;
        else if (newList != null)
            processList = newList;
        
        process (processList);
    }
    
    public static void afterOpportunity (List <Opportunity> oldList, List <Opportunity> newList) {
        Map <Id, Id> opportunityIdMap = new Map <Id, Id> ();
        
        if (oldList != null && newList != null) {
            Integer i = 0;
            
            for (Opportunity o : oldList) {
                if (o.Total_Finance_Amount__c != newList[i].Total_Finance_Amount__c || o.StageName != newList[i].StageName)
                    opportunityIdMap.put (o.Id, o.Id);
                
                i++;
            }
        }
        
        List <Relationship__c> relationshipList = [SELECT Relationship_Type__c,
                                                   Business__c,
                                                   Person__c
                                                   FROM Relationship__c
                                                   WHERE Related_Opportunity__c IN :opportunityIdMap.values ()
                                                  ];
        
        after (null, relationshipList);
    }
    
    private static void process (List <Relationship__c> processList) {
        Map <Id, Id> accountIdMap = new Map <Id, Id> ();
        Map <Id, Id> contactIdMap = new Map <Id, Id> ();
        
        for (Relationship__c r : processList) {
            if (r.Relationship_Type__c == 'Business Guarantee' && r.Business__c != null)
                accountIdMap.put (r.Business__c, r.Business__c);
            
            if (r.Relationship_Type__c == 'Personal Guarantee' && r.Person__c != null)
                contactIdMap.put (r.Person__c, r.Person__c);
        }
        
        List <Relationship__c> relationshipList = [SELECT Relationship_Type__c,
                                                   Business__c,
                                                   Person__c,
                                                   Related_Opportunity__r.Total_Finance_Amount__c
                                                   FROM Relationship__c
                                                   WHERE (
                                                       (Relationship_Type__c = 'Business Guarantee'
                                                        AND Business__c IN :accountIdMap.values ())
                                                       OR
                                                       (Relationship_Type__c = 'Personal Guarantee'
                                                        AND Person__c IN :contactIdMap.values ())
                                                       )
                                                   AND Related_Opportunity__r.StageName NOT IN ('090 - Funded/Booked', 'Cancelled', 'Declined')
                                                  ];
        
        Map <Id, Double> accountExposureMap = new Map <Id, Double> ();
        Map <Id, Double> contactExposureMap = new Map <Id, Double> ();
        
        for (Relationship__c r : relationshipList) {
            if (r.Related_Opportunity__r.Total_Finance_Amount__c != null) {
                if (r.Relationship_Type__c == 'Business Guarantee' && r.Business__c != null) {
                    Double exposure = accountExposureMap.get (r.Business__c);
                    
                    if (exposure == null)
                        accountExposureMap.put (r.Business__c, r.Related_Opportunity__r.Total_Finance_Amount__c);
                    else
                        accountExposureMap.put (r.Business__c, exposure + r.Related_Opportunity__r.Total_Finance_Amount__c);
                }
                
                if (r.Relationship_Type__c == 'Personal Guarantee' && r.Person__c != null) {
                    Double exposure = contactExposureMap.get (r.Person__c);
                    
                    if (exposure == null)
                        contactExposureMap.put (r.Person__c, r.Related_Opportunity__r.Total_Finance_Amount__c);
                    else
                        contactExposureMap.put (r.Person__c, exposure + r.Related_Opportunity__r.Total_Finance_Amount__c);
                }
            }
        }
        
        for (Relationship__c r : processList) {
            if (r.Relationship_Type__c == 'Business Guarantee' && r.Business__c != null && accountExposureMap.get (r.Business__c) == null)
                accountExposureMap.put (r.Business__c, 0);
            
            if (r.Relationship_Type__c == 'Personal Guarantee' && r.Person__c != null && contactExposureMap.get (r.Person__c) == null)
                contactExposureMap.put (r.Person__c, 0);
        }
        
        List <Account> accountList = [SELECT Id FROM Account WHERE id IN :accountExposureMap.keySet ()];
        List <Contact> contactList = [SELECT Id FROM Contact WHERE id IN :contactExposureMap.keySet ()];
        
        for (Account a : accountList)
            a.Pre_Funded_Indirect_Exposure__c = accountExposureMap.get (a.Id);
        
        for (Contact c : contactList)
            c.Pre_Funded_Exposure__c = contactExposureMap.get (c.Id);
        
        update accountList;
        update contactList;
    } 
}