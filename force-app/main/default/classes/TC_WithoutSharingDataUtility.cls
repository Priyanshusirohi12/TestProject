/**
 * Created on 2/3/18.
 */

public with sharing class TC_WithoutSharingDataUtility {


    public static Opportunity insertOpportunity (Opportunity opp) {
        insert opp;
        return opp;
    }

    public static List <Quote_Option__c> insertQuoteOptions (List <Quote_Option__c> options) {
        insert options;
        return options;
    }

    public static Opportunity getAllFieldsOnOpportunityByRecordId (String recordId, Set <String> parentFieldsSet) {
        return TC_DataUtility.getAllFieldsOnOpportunityByRecordId(recordId, parentFieldsSet);
    }
}