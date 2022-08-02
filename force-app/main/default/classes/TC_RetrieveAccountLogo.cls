/**
 * Created by tamarack on 1/2/20.
 */

public without sharing class TC_RetrieveAccountLogo {

    /*
    If a vendorId is present, first search for a logo if a related Vendor Program record is available. If not, then
    check the Logo URL field on the Vendor. Otherwise:

    Single-tenant Environment: Retrieve Account from Origination Setting's "Own Company Account Id" field, and search for
    for a corresponding Online Application custom metadata record. If no Logo URL in record, retrieve Logo URL from actual
    Account record.

    Multiple-tenant Environment: Retrieve the corresponding Online Application custom metadata record. If no Logo URL in
    record, retrieve Logo URL from actual Account record.
     */

    public static String retrieve(String accountId, String vendorId) {

        System.debug('=============== TC_RetrieveAccountLogo');
        String logoURL;

        // Single-tenant environment
        if (accountId == null || accountId == '') {
            Origination_Setting__c originationSetting = Origination_Setting__c.getOrgDefaults();
            accountId = originationSetting.Own_Company_Account_Id__c;
        }

        System.debug('accountId: ' + accountId + ', vendorId: ' + vendorId);
        Map<Id, Account> accountMap = new Map<Id, Account>([
                SELECT Id, Logo_URL__c
                FROM Account
                WHERE Id =: accountId OR Id =: vendorId]);
        System.debug('accountMap: ' + accountMap);

        if (vendorId != null && vendorId != '') {
            logoURL = accountMap.containsKey(vendorId) ? accountMap.get(vendorId).Logo_URL__c : null;
        }

        if (logoURL == null) {
            List<TC_Online_Application_Setting__mdt> mdt = new List<TC_Online_Application_Setting__mdt>([
                    SELECT Id, Logo_Url__c
                    FROM TC_Online_Application_Setting__mdt
                    WHERE Label =: accountId LIMIT 1
            ]);
            logoURL = (!mdt.isEmpty()) ? mdt[0].Logo_Url__c : null;
            if (logoURL == null) {
                logoURL = accountMap.containsKey(accountId) ? accountMap.get(accountId).Logo_URL__c : null;
            }
        }

        System.debug('final logoURL: ' + logoURL);

        return logoURL;

    }

    public static String retrieveHeaderBackgroundColor(String accountId, String vendorId) {
        System.debug('=============== retrieve background color');
        String backgroundColor;

        try {
            // Single-tenant environment
            if (accountId == null || accountId == '') {
                Origination_Setting__c originationSetting = Origination_Setting__c.getOrgDefaults();
                accountId = originationSetting.Own_Company_Account_Id__c;
            }

            System.debug('accountId: ' + accountId + ', vendorId: ' + vendorId);
            Map<Id, Account> accountMap = new Map<Id, Account>([
                    SELECT Id, Logo_URL__c, Application_Header_Color__c
                    FROM Account
                    WHERE Id =: accountId OR Id =: vendorId]);

            if (vendorId != null && vendorId != '') {
                backgroundColor = accountMap.containsKey(vendorId) ? accountMap.get(vendorId).Application_Header_Color__c : null;
            }

            if (backgroundColor == null) {
                List<TC_Online_Application_Setting__mdt> mdt = new List<TC_Online_Application_Setting__mdt>([
                        SELECT Id, Logo_Url__c, Background_Color__c
                        FROM TC_Online_Application_Setting__mdt
                        WHERE Label =: accountId LIMIT 1
                ]);
                backgroundColor = (!mdt.isEmpty()) ? mdt[0].Logo_Url__c : null;
                if (backgroundColor == null) {
                    backgroundColor = accountMap.containsKey(accountId) ? accountMap.get(accountId).Application_Header_Color__c : null;
                }
            }
        } catch(Exception e) {
            System.debug('Error retriving header color: ' + e.getMessage() + ' ~ ' + e.getStackTraceString());
        }
        

        System.debug('final backgroundColor: ' + backgroundColor);

        return (backgroundColor == null ? 'white' : backgroundColor);
    }

}