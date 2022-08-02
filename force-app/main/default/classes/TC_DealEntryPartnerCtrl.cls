/**
 * Created by szheng on 2019-08-21.
 */

public with sharing class TC_DealEntryPartnerCtrl {

    @AuraEnabled
    public static Id getRecordTypeId() {

        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
        return recordTypeMap.get('Vendor').recordTypeId;

    }

    @AuraEnabled
    public static Account selectPartner(String partnerId) {
        try {
            return TC_DataUtility.getAllFieldsOnAccountByRecordId(partnerId);
        } catch (Exception e) {
            System.debug(e);
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

}