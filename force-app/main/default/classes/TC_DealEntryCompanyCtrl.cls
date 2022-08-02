/**
 * Created by tamarack on 2019-08-13.
 */

public with sharing class TC_DealEntryCompanyCtrl {

    @AuraEnabled
    public static Id getRecordTypeId() {
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
        return recordTypeMap.get('Borrower').recordTypeId;
    }

    @AuraEnabled
    public static TC_DealEntryWizardCtrl.TC_DealWizardWrapper selectCompany(String wrapperString) {

        TC_DealEntryWizardCtrl.TC_DealWizardWrapper wrapper = (TC_DealEntryWizardCtrl.TC_DealWizardWrapper)
                System.JSON.deserialize(wrapperString, TC_DealEntryWizardCtrl.TC_DealWizardWrapper.class);

        Id companyId = wrapper.companyWrapper.company.Id;

        try {
            wrapper.companyWrapper.company = TC_DataUtility.getAllFieldsOnAccountByRecordId(companyId);

            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id,
            (SELECT Id, Person__c, Business__c, RecordType.Name FROM Relationships_Opportunity__r)
            FROM Opportunity
            WHERE AccountId =: companyId]);

            List<TC_DealEntryWizardCtrl.TC_GuarantorWrapper> companyPguarantorList = new
                    List<TC_DealEntryWizardCtrl.TC_GuarantorWrapper>();
            List<TC_DealEntryWizardCtrl.TC_GuarantorWrapper> companyCguarantorList = new
                    List<TC_DealEntryWizardCtrl.TC_GuarantorWrapper>();

            Set<Id> relatedRecordIds = new Set<Id>();

            for (Opportunity opp : oppMap.values()) {
                for (Relationship__c rel : opp.Relationships_Opportunity__r) {
                    if (rel.RecordType.Name == 'Individual' && rel.Person__c != null
                            && !relatedRecordIds.contains(rel.Person__c)) {

                        relatedRecordIds.add(rel.Person__c);

                        Relationship__c newRel = new Relationship__c(
                                Relationship_Type__c = 'Personal Guarantee'
                                , Person__r = getAllFieldsOnContactByRecordId(rel.Person__c)
                                , Person__c = rel.Person__c
                                , Signer__c = false
                                , RecordType = new RecordType(Name = 'Individual'));

                        TC_DealEntryWizardCtrl.TC_GuarantorWrapper guarWrapper = new
                                TC_DealEntryWizardCtrl.TC_GuarantorWrapper(newRel);

                        guarWrapper.isAccountRelated = true;
                        guarWrapper.contactReadOnly = true;
                        companyPguarantorList.add(guarWrapper);

                    } else if (rel.RecordType.Name == 'Corporation' && rel.Business__c != null
                            && !relatedRecordIds.contains(rel.Business__c)) {

                        relatedRecordIds.add(rel.Business__c);

                        Relationship__c newRel = new Relationship__c(
                                Relationship_Type__c = 'Business Guarantee'
                                , RecordType = new RecordType(Name = 'Corporation')
                                , Business__r = TC_DataUtility.getAllFieldsOnAccountByRecordId(rel.Business__c)
                                , Business__c = rel.Business__c);

                        TC_DealEntryWizardCtrl.TC_GuarantorWrapper guarWrapper = new
                                TC_DealEntryWizardCtrl.TC_GuarantorWrapper(newRel);

                        guarWrapper.isAccountRelated = true;
                        guarWrapper.accountReadOnly = true;
                        companyCguarantorList.add(guarWrapper);

                    }
                }
            }

            wrapper.companyWrapper.readOnly = true;
            wrapper.companyPguarantorList = companyPguarantorList;
            wrapper.companyPgSelected = 0;
            wrapper.companyCguarantorList = companyCguarantorList;
            wrapper.companyCgSelected = 0;

        } catch (Exception e) {
            System.debug(e);
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }

        return wrapper;
    }

    // Cannot use TC_DataUtility because it does not also pull in the Account.Name
    public static Contact getAllFieldsOnContactByRecordId(Id recordId) {

        Map <String, Schema.SObjectType> allSObjects = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectSchema = allSObjects.get('Contact');
        Schema.DescribeSObjectResult d = sObjectSchema.getDescribe();
        Map<String, Schema.SObjectField> fldObjMap = d.fields.getMap();

        String queryString = 'SELECT ';
        for(Schema.SObjectField s : fldObjMap.values()) {
            queryString += s.getDescribe().getName() + ',';
        }

        queryString += 'Account.Name FROM Contact WHERE Id=:recordId';

        return (Contact) Database.query(queryString);
    }

}