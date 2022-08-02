/**
 * Created on 2019-01-24.
 */
global with sharing class LookupCreditApproverForOpportunity {

    @InvocableMethod(label='Lookup Approvers by Credit Authority for Partner User' description='Finds approver for specific partner account.')
    public static void getApprovers (List<String> oppIds) {
        List <Opportunity> opps = new List <Opportunity> ([
            SELECT Id, Total_Finance_Amount__c
            FROM Opportunity
            WHERE Id IN :oppIds
        ]);

        User currentUser = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        List<User> approvers = new list<User>();

        if (currentUser.ContactId != null) {

            // Within multi-tenant environment: must search only among users within partner community
            approvers = new List <User> ([
                    SELECT Id, Credit_Authority__c
                    FROM User
                    WHERE AccountId = :currentUser.AccountId AND IsActive = true AND Credit_Authority__c != null
                    ORDER BY Credit_Authority__c ASC LIMIT 1000]); //we might need to rethink this once we hit that scale

        } else {

            // Within single-tenant environment: may search all users
            approvers = new List <User> ([
                    SELECT Id, Credit_Authority__c
                    FROM User
                    WHERE IsActive = true AND Credit_Authority__c != null
                    ORDER BY Credit_Authority__c ASC LIMIT 1000]); //we might need to rethink this once we hit that scale

        }

        if (!approvers.isEmpty()) {

            for (Opportunity opp: opps) {

                //System.debug(opp.Total_Finance_Amount__c);

                for (User u : approvers) {
                    System.debug(u.Id + ' - Credit_Authority__c=' + u.Credit_Authority__c);
                    if (opp.Total_Finance_Amount__c <= u.Credit_Authority__c) {
                        opp.Credit_Analyst__c = u.Id;
                        //System.debug('found user with closes credit approval - ' + u.Id);
                        break;
                    }
                }

            }

            update opps;
        }
    }
}