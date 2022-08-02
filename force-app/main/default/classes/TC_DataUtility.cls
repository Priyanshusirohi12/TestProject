/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 06/23/2015
* @description: Customer Portal
*
* © Copyright 2003 - 2017 Tamarack Consulting, Inc.  All Rights Reserved.
*
*/

public with sharing class TC_DataUtility {
    public static String createSelectAllQueryString (String sObjectApiName, String whereClause, Set <String> parentFieldsSet) {
        if (parentFieldsSet == null) parentFieldsSet = new Set <String> ();

        Map <String, Schema.SObjectType> allSObjects = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectSchema = allSObjects.get(sObjectApiName);
        Schema.DescribeSObjectResult d = sObjectSchema.getDescribe();
        Map<String, Schema.SObjectField> fldObjMap = d.fields.getMap();

        String queryString = 'SELECT ';
        for(Schema.SObjectField s : fldObjMap.values()) {
            queryString += s.getDescribe().getName() + ',';
        }

        if (!parentFieldsSet.isEmpty()) {
            for (String s: parentFieldsSet) {
                queryString += s + ',';
            }
        }

        // Trim last comma
        queryString = queryString.removeEnd(',');

        // Finalize query string
        queryString += ' FROM ' + sObjectApiName;
        queryString += ' WHERE ';

        if (!String.isEmpty(whereClause)) {
            queryString += whereClause;
        } else {
            queryString += 'Id != null LIMIT 1000';
        }
        
        return queryString;
    }

    public static Opportunity getAllFieldsOnOpportunityByRecordId (String recordId) {
        return TC_DataUtility.getAllFieldsOnOpportunityByRecordId (recordId, null);
    }

    public static Opportunity getAllFieldsOnOpportunityByRecordId (String recordId, Set <String> parentFieldsSet) {
        String q = TC_DataUtility.createSelectAllQueryString('Opportunity', ' Id=:recordId', parentFieldsSet);
        return (Opportunity) Database.query(q);
    }

    public static Account getAllFieldsOnAccountByRecordId (String recordId) {
        return TC_DataUtility.getAllFieldsOnAccountByRecordId (recordId, null);
    }

    public static Account getAllFieldsOnAccountByRecordId (String recordId, Set <String> parentFieldsSet) {
        String q = TC_DataUtility.createSelectAllQueryString('Account', ' Id=:recordId', parentFieldsSet);
        System.debug(recordId);
        return (Account) Database.query(q);
    }

    public static Contact getAllFieldsOnContactByRecordId (String recordId) {
        return TC_DataUtility.getAllFieldsOnContactByRecordId (recordId, null);
    }

    public static Contact getAllFieldsOnContactByRecordId (String recordId, Set <String> parentFieldsSet) {
        String q = TC_DataUtility.createSelectAllQueryString('Contact', ' Id=:recordId', parentFieldsSet);
        return (Contact) Database.query(q);
    }

    public static Like_Term_Swap__c getAllFieldsOnLikeTermSwapLimitMostRecent () {
        String q = TC_DataUtility.createSelectAllQueryString('Like_Term_Swap__c', ' Id != NULL ORDER BY Date__c DESC LIMIT 1', null);
        List<Like_Term_Swap__c> ltsList = Database.query(q);
        Like_Term_Swap__c lts = (ltsList.isEmpty()) ? null : ltsList[0];
        return lts;
    }

}