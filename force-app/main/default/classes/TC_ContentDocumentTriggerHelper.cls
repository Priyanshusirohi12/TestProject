/**
 * Created by szheng on 2019-07-03.
 */

public with sharing class TC_ContentDocumentTriggerHelper {

    public static void deleteAccountLogo(Map <Id, ContentDocument> oldMap) {


        // Retrieve deleted documents of name "accountLogo"
        Map <Id, ContentDocument> cdMap = new Map <Id, ContentDocument> ([SELECT Id FROM ContentDocument WHERE Id IN :oldMap.keySet() AND Title='accountLogo']);
        if (cdMap.isEmpty ()) {
            return;
        }

        // Retrieve corresponding ContentDocumentLink.linkedEntityIds while confirming parent is Account record
        Map <Id, ContentDocumentLink> cdlMap = new Map<Id, ContentDocumentLink>([SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :oldMap.keySet()]);
        Set <Id> cdlIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdlMap.values()) {
            if (cdl.LinkedEntityId.getSObjectType () == Schema.Account.getSObjectType ()) {
                cdlIds.add (cdl.Id);
            }
        }

        List<Account> accounts = new List<Account>();
        for (Id cdlId : cdlIds) {
            accounts.add(new Account(Id = cdlMap.get(cdlId).LinkedEntityId, Logo_Url__c = ''));
        }
        upsert accounts;

    }
}