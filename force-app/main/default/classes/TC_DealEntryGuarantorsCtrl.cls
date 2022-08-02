/**
 * Created by tamarack on 2019-08-15.
 */

public with sharing class TC_DealEntryGuarantorsCtrl {

    @AuraEnabled
    public static Map<String, String> getRecordType() {
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Relationship__c.getRecordTypeInfosByName();
        Map<String, String> recordTypeReturn = new Map<String, String>();
        for (String recordName : recordTypeMap.keySet()) {
            recordTypeReturn.put(recordName, recordTypeMap.get(recordName).recordTypeId);
        }
        return recordTypeReturn;
    }

    @AuraEnabled
    public static Map<String, String> getRecordTypePicklist() {
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Contact.getRecordTypeInfosByName();
        Map<String, String> recordTypeReturn = new Map<String, String>();
        for (String recordName : recordTypeMap.keySet()) {
            recordTypeReturn.put(recordName, recordTypeMap.get(recordName).recordTypeId);
        }
        return recordTypeReturn;
    }

    @AuraEnabled
    public static TC_DealEntryWizardCtrl.TC_DealWizardWrapper selectPGuarantorCtrl(String wrapperString, String contactId, Integer index) {

        TC_DealEntryWizardCtrl.TC_DealWizardWrapper wrapper = (TC_DealEntryWizardCtrl.TC_DealWizardWrapper)
                System.JSON.deserialize(wrapperString, TC_DealEntryWizardCtrl.TC_DealWizardWrapper.class);

        TC_DealEntryWizardCtrl.TC_GuarantorWrapper guarantorWrapper = selectPGuarantor(contactId);

       if (!wrapper.pguarantorList.isEmpty()) {
           wrapper.pguarantorList[index] = guarantorWrapper;
       } else {
           wrapper.pguarantorList.add(guarantorWrapper);
       }

        return wrapper;
    }

    public static TC_DealEntryWizardCtrl.TC_GuarantorWrapper selectPGuarantor(String contactId) {
        try {
            Contact contact = TC_DataUtility.getAllFieldsOnContactByRecordId(contactId);
            if (contact.AccountId != null) {
                contact.Account = TC_DataUtility.getAllFieldsOnAccountByRecordId(contact.AccountId);
            }
            Relationship__c relationship = new Relationship__c(Person__r = contact,
                    Relationship_Type__c = 'Personal Guarantee', RecordType = new RecordType(Name = 'Individual'));
            TC_DealEntryWizardCtrl.TC_GuarantorWrapper guarantorWrapper = new TC_DealEntryWizardCtrl.TC_GuarantorWrapper(relationship);
            guarantorWrapper.contactReadOnly = true;
            return guarantorWrapper;
        } catch (Exception e) {
            System.debug(e);
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static TC_DealEntryWizardCtrl.TC_DealWizardWrapper selectCGuarantorCtrl(String wrapperString, String accountId, Integer index) {

        TC_DealEntryWizardCtrl.TC_DealWizardWrapper wrapper = (TC_DealEntryWizardCtrl.TC_DealWizardWrapper)
                System.JSON.deserialize(wrapperString, TC_DealEntryWizardCtrl.TC_DealWizardWrapper.class);

        TC_DealEntryWizardCtrl.TC_GuarantorWrapper guarantorWrapper = selectCGuarantor(accountId);

        if (!wrapper.cguarantorList.isEmpty()) {
            wrapper.cguarantorList[index] = guarantorWrapper;
        } else {
            wrapper.cguarantorList.add(guarantorWrapper);
        }

        return wrapper;
    }

    public static TC_DealEntryWizardCtrl.TC_GuarantorWrapper selectCGuarantor(String accountId) {
        try {
            Account account = TC_DataUtility.getAllFieldsOnAccountByRecordId(accountId);
            Relationship__c relationship = new Relationship__c(Business__r = account,
                    Relationship_Type__c = 'Business Guarantee', RecordType = new RecordType(Name = 'Corporation'));
            TC_DealEntryWizardCtrl.TC_GuarantorWrapper guarantorWrapper = new TC_DealEntryWizardCtrl.TC_GuarantorWrapper(relationship);
            guarantorWrapper.accountReadOnly = true;
            return guarantorWrapper;
        } catch (Exception e) {
            System.debug(e);
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

}