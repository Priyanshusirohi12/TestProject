public class TC_OriginatorHelper {
    
    public static Set <String> allowedAccountRecordTypes = new Set <String> {'Broker','Vendor'};
    
    public static void tieBrokerAndRepToApp (Map <Id, SObject> objects) {
    
        // Ties broker and broker rep by brokers email
        // if unable to find a match it tries to find broker by website (split email)
        
        

        Map <Id, String> emails = new Map <Id, String> ();
        
        for (SObject obj : objects.values ()) {
            if (obj.get ('Originator_Email__c') != null) {
                emails.put (obj.Id, String.valueOf (obj.get ('Originator_Email__c')));
            }
        }
        
        if (!emails.isEmpty ()) {
            Map <String, Contact> emailContactMap = new Map <String, Contact> ();
            
            for (Contact con : [SELECT Id, Email, AccountId FROM Contact WHERE Email IN :emails.values () AND Account.RecordType.DeveloperName IN :allowedAccountRecordTypes]) {
                emailContactMap.put (con.Email, con);
            }
            
            List <SObject> updateList = new List <SObject> ();
            Set <Id> matchedIds = new Set <Id> ();
            
            for (Id objId : emails.keySet ()) {
                if (emailContactMap.get (emails.get (objId)) != null && emailContactMap.get (emails.get (objId)).Id != null) {
                    matchedIds.add (objId);
                    if (objId.getSObjectType () == Schema.Lead.getSObjectType ()) {
                        updateList.add (new Lead (Id = objId, Broker__c = emailContactMap.get (emails.get (objId)).AccountId, Broker_Sales_Rep__c = emailContactMap.get (emails.get (objId)).Id));
                    } else if (objId.getSObjectType () == Schema.Opportunity.getSObjectType ()) {
                        updateList.add (new Opportunity (Id = objId, Broker__c = emailContactMap.get (emails.get (objId)).AccountId, Broker_Sales_Rep__c = emailContactMap.get (emails.get (objId)).Id));
                    }
                }
                
            }
            
            // find apps that don't have a broker salesrep and attempt to match on website
            Map <String, Id> noMatchWithWebsite = new Map <String, Id> ();
            
            for (Id objId : emails.keySet ()) {
                if (!matchedIds.contains (objId)) {
                    // email validation in salesforce ensures there will always only be one @ if there's a value
                    noMatchWithWebsite.put (String.valueOf (objects.get (objId).get ('Originator_Email__c')).split ('@')[1], objId);
                }
            }
            
            if (!noMatchWithWebsite.isEmpty ()) {
            
                Set <String> websitesWithLike = new Set <String> ();

                for (String website : noMatchWithWebsite.keySet ()) {
                    websitesWithLike.add ('%' + website);
                }

                for (Account acc : [SELECT Id, Website FROM Account WHERE Website Like :websitesWithLike AND RecordType.DeveloperName IN :allowedAccountRecordTypes]) {
                    
                    for (String website : noMatchWithWebsite.keySet ()) {
                        
                        if (acc.Website.contains (website)) {
                            if (noMatchWithWebsite.get (website) != null) {
                                if (noMatchWithWebsite.get (website).getSObjectType () == Schema.Lead.getSObjectType ()) {
                                    updateList.add (new Lead (Id = noMatchWithWebsite.get (website), Broker__c = acc.Id));
                                } else if (noMatchWithWebsite.get (website).getSObjectType () == Schema.Opportunity.getSObjectType ()) {
                                    updateList.add (new Opportunity (Id = noMatchWithWebsite.get (website), Broker__c = acc.Id));
                                }
                            }
                            
                        }
                    }
                }
                
                
            }
            
            try {
                update updateList;
            } catch (Exception e) {
            
            }
            
        }
    }
    
    
    public static void tieAppToBrokerAndRep (Map <Id, Contact> conMap) {
        
        // check if contact is a broker or vendor contact
        List <Contact> contacts = new List <Contact> ([SELECT Id, AccountId, Email FROM Contact WHERE Id IN :conMap.keySet () AND Account.RecordType.DeveloperName IN :allowedAccountRecordTypes]);
        
        Map <String, Contact> emails = new Map <String, Contact> ();
        
        for (Contact con : contacts) {
            emails.put (con.Email, con);
        }
        
        if (!emails.isEmpty ()) {
        
            List <SObject> updateList = new List <SObject> ();
            
            for (Lead l : [SELECT Id, Originator_Email__c FROM Lead WHERE Broker__c = null AND Broker_Sales_Rep__c = null AND Originator_Email__c IN :emails.keySet () AND IsConverted = false]) {
                updateList.add (new Lead (Id = l.Id
                                            , Broker__c = emails.get (l.Originator_Email__c).AccountId
                                            , Broker_Sales_Rep__c = emails.get (l.Originator_Email__c).Id));
            }
            
            for (Opportunity opp : [SELECT Id, Originator_Email__c FROM Opportunity WHERE Broker__c = null AND Broker_Sales_Rep__c = null AND Originator_Email__c IN :emails.keySet () AND IsClosed = false]) {
                updateList.add (new Opportunity (Id = opp.Id
                                                , Broker__c = emails.get (opp.Originator_Email__c).AccountId
                                                , Broker_Sales_Rep__c = emails.get (opp.Originator_Email__c).Id));
            }
            
            try {
                update updateList;
            } catch (Exception e) {
                System.debug (e);
            }
            
            
            
            
        }
    }
}