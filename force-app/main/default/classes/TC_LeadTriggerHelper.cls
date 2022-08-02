/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 1/27/2017
* @description: Lead trigger handler
*
* © Copyright 2003 - 2017 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/


public with sharing class TC_LeadTriggerHelper {
    public static void afterUpdate (Map <Id, Lead> triggerNewMap, Map <Id, Lead> triggerOldMap) {
        TC_LeadConversion.processContacts(triggerNewMap, triggerOldMap);
    }
    
    public static void originatorEmailChanged (Map <Id, Lead> oldMap, Map <Id, Lead> newMap) {
        System.debug ('>>>>> made it lead trigger helper');
        Map <Id, Lead> changedMap = new Map <Id, Lead> ();
        
        for (Lead l : newMap.values ()) {
            if (l.Originator_Email__c != null && l.Broker_Sales_Rep__c == null && l.Broker__c == null && (oldMap == null || (oldMap.get (l.Id).Originator_Email__c != l.Originator_Email__c))) {
                changedMap.put (l.Id, l);
            }
        }
        
        if (!changedMap.isEmpty () && TC_CheckRecursiveOriginatorLead.runOnce ()) {
            TC_OriginatorHelper.tieBrokerAndRepToApp (changedMap);
        }
    }
    
}