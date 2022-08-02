public with sharing class TC_OpportunityTriggerHelper {

    public static void originatorEmailChanged (Map <Id, Opportunity> oldMap, Map <Id, Opportunity> newMap) {

        Map <Id, Opportunity> changedMap = new Map <Id, Opportunity> ();
        
        for (Opportunity o : newMap.values ()) {
            if (o.Originator_Email__c != null && o.Broker_Sales_Rep__c == null && o.Broker__c == null && (oldMap == null || (oldMap.get (o.Id).Originator_Email__c != o.Originator_Email__c))) {
                changedMap.put (o.Id, o);
            }
        }
        
        if (!changedMap.isEmpty () && TC_CheckRecursiveOriginatorOpp.runOnce ()) {
            TC_OriginatorHelper.tieBrokerAndRepToApp (changedMap);
        }
    }

    /// Originator Sharing for Partner Portal
    public static void shareWithOriginator (Map <Id, Opportunity> oldMap, Map <Id, Opportunity> newMap) {
        
        Map <Id, Set <Opportunity>> newOriginators = new Map <Id, Set <Opportunity>> (); // add sharing to these
        Map <Id, Set <Opportunity>> oldOriginators = new Map <Id, Set <Opportunity>> (); // remove sharing from these
        Set <Id> oldOppIds = new Set <Id> ();
        Set <Id> oldAccIds = new Set <Id> ();
        
        for (Opportunity opp : newMap.values ()) {
            if (oldMap == null || opp.Broker__c != oldMap.get (opp.Id).Broker__c) { 
                if (opp.Broker__c != null) {
                    if (newOriginators.get (opp.Broker__c) != null) {
                        newOriginators.get (opp.Broker__c).add (opp);
                    } else {
                        newOriginators.put (opp.Broker__c, new Set <Opportunity> {opp});
                    }
                }
                if (oldMap != null && opp.Broker__c != oldMap.get (opp.Id).Broker__c) {
                    oldOppIds.add (opp.Id);
                    
                    if (oldMap.get (opp.Id).AccountId != null) oldAccIds.add (oldMap.get (opp.Id).AccountId);
                    
                    if (oldOriginators.get (oldMap.get (opp.Id).Broker__c) != null) {
                        oldOriginators.get (oldMap.get (opp.Id).Broker__c).add (opp);
                    } else {
                        oldOriginators.put (oldMap.get (opp.Id).Broker__c, new Set <Opportunity> {opp});
                    }
                }
            }
        }
        
        System.debug('>>>> oldOriginators: ' + oldOriginators);
        
        Set <Id> origIds = new Set <Id> ();
        origIds.addAll (newOriginators.keySet());
        origIds.addAll(oldOriginators.keySet());
        
        // assosiste broker with a group
        Map <Id, UserRole> userRoles = new Map <Id, UserRole> ([SELECT Id, PortalAccountId, DeveloperName FROM UserRole WHERE PortalAccountId IN :origIds]);
        Map <Id, Id> partnerGroupMap = new Map <Id, Id> ();
        Map <Id, Id> groupPartnerMap = new Map <Id, Id> ();
        
        for (Group grp : [SELECT Id, RelatedId FROM Group WHERE RelatedId IN :userRoles.keySet ()]) {
            partnerGroupMap.put (userRoles.get (grp.RelatedId).PortalAccountId, grp.Id);
            groupPartnerMap.put (grp.Id, userRoles.get (grp.RelatedId).PortalAccountId);
        }

/* removed for deployment

        // share with opportunity & account
        List <SObject> newShares = new List <SObject> ();
        Map <Id, Set <Id>> oppWithOriginator = new Map <Id, Set <Id>> ();
        
        for (Id origId : newOriginators.keySet()) {
            for (Opportunity opp : newOriginators.get(origId)) {
                newShares.add (new OpportunityShare (OpportunityAccessLevel = 'Read', OpportunityId = opp.Id, UserOrGroupId = partnerGroupMap.get (opp.Broker__c)));
                
                if (oppWithOriginator.get (opp.Id) != null) {
                    oppWithOriginator.get (opp.Id).add (opp.Broker__c);
                } else {
                    oppWithOriginator.put (opp.Id, new Set <Id> {opp.Broker__c});
                }
                
                if (opp.AccountId != null) newShares.add (new AccountShare (AccountAccessLevel = 'Read', OpportunityAccessLevel = 'Read', AccountId = opp.AccountId, UserOrGroupId = partnerGroupMap.get (opp.Broker__c)));
            }
        }
        
        // add checklist permissions
        for (TC_Origination__Checklist__c checklist : [SELECT Id, TC_Origination__Opportunity__c FROM TC_Origination__Checklist__c WHERE TC_Origination__Opportunity__c IN :oppWithOriginator.keySet ()]) {
            for (Id origId : oppWithOriginator.get (checklist.TC_Origination__Opportunity__c)) {
                newShares.add (new TC_Origination__Checklist__Share (ParentId = checklist.Id, AccessLevel = 'Read', UserOrGroupId = partnerGroupMap.get (origId)));
            }
        }
        
        // remove share logic
        List <SObject> oldShares = new List <SObject> ();

        // remove old opportunity sharing
        for (OpportunityShare share : [SELECT Id, OpportunityId, UserOrGroupId FROM OpportunityShare WHERE OpportunityId IN :oldOppIds]) {
            if (oldOriginators.get (groupPartnerMap.get (share.UserOrGroupId)) != null && oldOriginators.get (groupPartnerMap.get (share.UserOrGroupId)).contains (new Opportunity (Id = share.OpportunityId))) {
                oldShares.add (new OpportunityShare (Id = share.Id));
            }
        }
        
        // remove old account sharing
        for (AccountShare share : [SELECT Id, AccountId, UserOrGroupId FROM AccountShare WHERE AccountId IN :oldAccIds]) {
            if (oldOriginators.get (groupPartnerMap.get (share.UserOrGroupId)) != null) {
                
                Set <Id> accIds = new Set <Id> ();
                for (Opportunity opp : oldOriginators.get (groupPartnerMap.get (share.UserOrGroupId))) {
                    accIds.add (opp.AccountId);
                }
                if (accIds.contains (share.AccountId)) oldShares.add (new AccountShare (Id = share.Id));
            }
        }
        
        // remove old checklist sharing
        for (TC_Origination__Checklist__Share share : [SELECT Id, ParentId, UserOrGroupId, Parent.TC_Origination__Opportunity__c FROM TC_Origination__Checklist__Share WHERE Parent.TC_Origination__Opportunity__c IN :oldOppIds]) {
            if (oldOriginators.get (groupPartnerMap.get (share.UserOrGroupId)) != null) {
                
                if (oldOriginators.get (groupPartnerMap.get (share.UserOrGroupId)) != null && oldOriginators.get (groupPartnerMap.get (share.UserOrGroupId)).contains (new Opportunity (Id = share.Parent.TC_Origination__Opportunity__c))) {
	                oldShares.add (new TC_Origination__Checklist__Share (Id = share.Id));
            	}
            }
        }

        
        insert newShares;
        delete oldShares;
*/
    }

    // Line of Credit: Logic for updating Account's LOC Approval Used Amount when Opportunity's LOC or Balance Amount changes
    // Gitlab: Origination #219, LenderKiosk_Accelerator 3.0 #260
    public static void updateLOCUsedAmount(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {

        Set<String> locIdSet = new Set<String>();

        if (oldMap == null) {
            for (Opportunity opp : newMap.values()) {
                locIdSet.add(opp.Line_of_Credit_Approval__c);
            }
        } else {
            for (Opportunity opp : newMap.values()) {
                if (opp.Line_of_Credit_Approval__c != null && opp.Balance_Amount__c != null) {
                    if (opp.Line_of_Credit_Approval__c != oldMap.get(opp.Id).Line_of_Credit_Approval__c) {
                        locIdSet.add(opp.Line_of_Credit_Approval__c);
                        locIdSet.add(oldMap.get(opp.Id).Line_of_Credit_Approval__c);
                    } else if (opp.Balance_Amount__c != oldMap.get(opp.Id).Balance_Amount__c) {
                        locIdSet.add(opp.Line_of_Credit_Approval__c);
                    }
                } else {
                    if (oldMap.get(opp.Id).Line_of_Credit_Approval__c != null ||
                            opp.Balance_Amount__c != oldMap.get(opp.Id).Balance_Amount__c) {
                        locIdSet.add(oldMap.get(opp.Id).Line_of_Credit_Approval__c);
                    }
                }
            }
        }

        List<Line_of_Credit_Approval__c> locList = new List<Line_of_Credit_Approval__c>([
                SELECT Id, Used_Amount__c,Available_Amount__c,Approved_Amount__c,Revolving__c,
                (SELECT Id, Balance_Amount__c FROM Opportunities__r WHERE Balance_Amount__c != null)
                FROM Line_of_Credit_Approval__c
                WHERE Id IN: locIdSet]);

        List<Line_of_Credit_Approval__c> locUpdateList = new List<Line_of_Credit_Approval__c>();
        for (Line_of_Credit_Approval__c loc : locList) {
            Decimal updatedUsedAmount = loc.Used_Amount__c;
            for (Opportunity opp : loc.Opportunities__r) {
                if (oldMap == null || (oldMap.containsKey(opp.Id) && oldMap.get(opp.Id).Balance_Amount__c == null)) {
                    updatedUsedAmount += opp.Balance_Amount__c;
                } else if (loc.Revolving__c && oldMap != null && oldMap.containsKey(opp.Id) &&
                        oldMap.get(opp.Id).Balance_Amount__c != opp.Balance_Amount__c) {
                    updatedUsedAmount -= oldMap.get(opp.Id).Balance_Amount__c;
                    updatedUsedAmount += opp.Balance_Amount__c;
                }
            }
            for (Opportunity opp : loc.Opportunities__r) {
                if (updatedUsedAmount > loc.Approved_Amount__c && newMap.containsKey(opp.Id)) {
                    Opportunity errorOpp = newMap.get(opp.Id);
                    errorOpp.addError('Invalid balance amount. Exceeds Line of Credit Approval\'s available amount.');
                }
            }
            loc.Used_Amount__c = updatedUsedAmount;
            locUpdateList.add(loc);
        }

        update locUpdateList;

    }

    public static void updateCOF_LTSInformation(Map<Id, Opportunity> oldMap, List<Opportunity> newList) {

        Like_Term_Swap__c ltsRecent = !Test.isRunningTest() ? TC_DataUtility.getAllFieldsOnLikeTermSwapLimitMostRecent() : new Like_Term_Swap__c();
        Set<String> ltsFields = Schema.SObjectType.Like_Term_Swap__c.fields.getMap().keySet();

        List<Cost_of_Fund__c> cofList = new List<Cost_of_Fund__c> ([SELECT Date__c, X12__c,X13_24__c,X25_36__c,X37_48__c
                ,X49_60__c,X61_72__c,X73_84__c,X85_96__c,X97_108__c
                ,X109_120__c
        FROM Cost_of_Fund__c
        ORDER BY Date__c Desc]);

        if (ltsRecent != null && ltsRecent.Id != null && !cofList.isEmpty()) {

            for (Opportunity opp : newList) {

                Boolean updateOpp = false;

                if (opp.Id == null) {
                    updateOpp = true;
                } else {
                    Boolean diffCOF = oldMap.get(opp.Id).COF__c != opp.COF__c;
                    Boolean lockedCOF = opp.COF_Lock__c;
                    Boolean notFromCoFTrigger = !opp.From_CoF_Trigger__c;
                    Boolean diffLockedCOF = oldMap.get(opp.Id).COF_Lock__c != opp.COF_Lock__c;
                    Boolean diffTerm = oldMap.get(opp.Id).Term__c != opp.Term__c;
                    Boolean diffDate = oldMap.get(opp.Id).COF_Date__c != opp.COF_Date__c ;
                    if (diffCOF && !lockedCOF && notFromCoFTrigger) {
                        opp.addError('COF value cannot be edited unless COF Override has been activated');
                    } else if (!diffCOF && !lockedCOF || diffLockedCOF && !lockedCOF || diffTerm || diffDate) {
                        updateOpp = true;
                        if (diffTerm) {
                            opp.COF_Date__c = null;
                            opp.COF_Lock__c = false;
                        }
                    }
                }

                Integer oppTerm = (Integer) opp.Term__c;
                String termAPIName = '';
                if (oppTerm == 12) termAPIName = 'X12__c';
                else if (13 <= oppTerm || oppTerm <= 24) termAPIName = 'X13_24__c';
                else if (25 <= oppTerm || oppTerm <= 36) termAPIName = 'X25_36__c';
                else if (37 <= oppTerm || oppTerm <= 48) termAPIName = 'X37_48__c';
                else if (49 <= oppTerm || oppTerm <= 60) termAPIName = 'X49_60__c';
                else if (61 <= oppTerm || oppTerm <= 72) termAPIName = 'X61_72__c';
                else if (73 <= oppTerm || oppTerm <= 84) termAPIName = 'X73_84__c';
                else if (85 <= oppTerm || oppTerm <= 96) termAPIName = 'X85_96__c';
                else if (97 <= oppTerm || oppTerm <= 108) termAPIName = 'X97_108__c';
                else if (109 <= oppTerm || oppTerm <= 120) termAPIName = 'X109_120__c';

                if (updateOpp) {

                    opp.COF__c = null;

                    if (oppTerm >= 12 && oppTerm <= 120) {
                        Date oppDate = opp.COF_Date__c;
                        if (oppDate == null) {
                            opp.COF__c = (Decimal) cofList[0].get(termAPIName);
                        } else {
                            for (Cost_of_Fund__c cof : cofList) {
                                if (cof.Date__c <= oppDate) {
                                    opp.COF__c = (Decimal) cof.get(termAPIName);
                                    break;
                                }
                            }
                        }
                    }

                }

                termAPIName = 'x' + String.valueOf(oppTerm) + '__c';
                if (ltsFields.contains(termAPIName)) {
                    opp.LTS__c = (ltsRecent.Id != null) ? (Decimal) ltsRecent.get(termAPIName) : null;
                }

                opp.From_CoF_Trigger__c = false;

            }
        }

    }

}