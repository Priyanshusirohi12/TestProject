/**
 * Created by tamarack on 2019-08-13.
 */

public class TC_DealEntryWizardCtrl {

    @AuraEnabled
    public static TC_DealWizardWrapper initMethod() {
        TC_DealWizardWrapper wrapperClass = new TC_DealWizardWrapper();
        return wrapperClass;
    }

    @AuraEnabled
    public static String submitDealCtrl(String dealString, String companyString, String companyPguarantorString,
            String companyCguarantorString, String pguarantorString, String cguarantorString, String equipmentString,
            String partnerString) {

        try {

            Opportunity deal = (Opportunity) System.JSON.deserialize(dealString, Opportunity.class);

            List<Account> insertAccountList = new List<Account>();
            List<Account> updateAccountList = new List<Account>();

            Account company;
            if (!String.isBlank(companyString)) {
                company = (Account) System.JSON.deserialize(companyString, Account.class);
                if (company.Id == null) {
                    insertAccountList.add(company);
                } else {
                    updateAccountList.add(company);
                }
            }

            Account partner;
            if (!String.isBlank(partnerString)) {
                partner = (Account) System.JSON.deserialize(partnerString, Account.class);
                if (partner.Id == null) {
                    insertAccountList.add(partner);
                } else {
                    updateAccountList.add(partner);
                }
            }

            dmlInsertAccounts(insertAccountList);
            update updateAccountList;

            deal.AccountId = (company == null) ? null : company.Id;
            deal.Broker__c = (partner == null) ? null : partner.Id;

            insert deal;
            Id oppId = deal.Id;

            List<Relationship__c> totalRelationshipList = new List<Relationship__c>();

            List<Relationship__c> companyPguarantorList = (List<Relationship__c>)
                    System.JSON.deserialize(companyPguarantorString, List<Relationship__c>.class);
            for (Integer i = 0; i < companyPguarantorList.size(); i++) {
                companyPguarantorList[i].Related_Opportunity__c = oppId;
                companyPguarantorList[i].Person__r = null;
            }
            totalRelationshipList.addAll(companyPguarantorList);

            List<Relationship__c> companyCguarantorList = (List<Relationship__c>)
                    System.JSON.deserialize(companyCguarantorString, List<Relationship__c>.class);
            for (Integer i = 0; i < companyCguarantorList.size(); i++) {
                companyCguarantorList[i].Related_Opportunity__c = oppId;
                companyCguarantorList[i].Business__r = null;
            }
            totalRelationshipList.addAll(companyCguarantorList);

            List<Contact> insertContactList = new List<Contact>();
            List<Contact> updateContactList = new List<Contact>();
            List<Relationship__c> pguarantorList = (List<Relationship__c>)
                    System.JSON.deserialize(pguarantorString, List<Relationship__c>.class);
            Map<Integer, Contact> relContactMap = new Map<Integer, Contact>();
            for (Integer i = 0; i < pguarantorList.size(); i++) {
                if (pguarantorList[i].Person__r.Id == null) {
                    insertContactList.add(pguarantorList[i].Person__r);
                } else {
                    updateContactList.add(pguarantorList[i].Person__r);
                }
                pguarantorList[i].Person__r.AccountId = deal.AccountId;
                pguarantorList[i].Person__r.Account = null;
                relContactMap.put(i, pguarantorList[i].Person__r);
            }
            dmlInsertContacts(insertContactList);
            update updateContactList;

            for (Integer i = 0; i < pguarantorList.size(); i++) {
                pguarantorList[i].Related_Opportunity__c = oppId;
                pguarantorList[i].Person__c = relContactMap.get(i).Id;
                totalRelationshipList.add(pguarantorList[i]);
            }

            insertAccountList = new List<Account>();
            updateAccountList = new List<Account>();
            List<Relationship__c> cguarantorList = (List<Relationship__c>)
                    System.JSON.deserialize(cguarantorString, List<Relationship__c>.class);
            Map<Integer, Account> relAccountMap = new Map<Integer, Account>();
            for (Integer i = 0; i < cguarantorList.size(); i++) {
                if (cguarantorList[i].Business__r.Id == null) {
                    insertAccountList.add(cguarantorList[i].Business__r);
                } else {
                    updateAccountList.add(cguarantorList[i].Business__r);
                }
                relAccountMap.put(i, cguarantorList[i].Business__r);
            }
            dmlInsertAccounts(insertAccountList);
            update updateAccountList;

            for (Integer i = 0; i < cguarantorList.size(); i++) {
                cguarantorList[i].Related_Opportunity__c = oppId;
                cguarantorList[i].Business__c = relAccountMap.get(i).Id;
                totalRelationshipList.add(cguarantorList[i]);
            }

            insert totalRelationshipList;

            List<Equipment__c> equipmentList = (List<Equipment__c>)
                    System.JSON.deserialize(equipmentString, List<Equipment__c>.class);
            for (Equipment__c equipment : equipmentList) {
                equipment.Opportunity__c = oppId;
            }
            insert equipmentList;

            return oppId;

        } catch (Exception ex) {
            System.debug(ex);
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }

    }

    public static void dmlInsertContacts(List<Contact> contactList) {

        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = FALSE;

        List<Database.SaveResult> saveResults = Database.insert(contactList, dml);
        for(Integer i=0; i < saveResults.size(); i++) {
            Database.SaveResult saveResult = saveResults.get(i);
            if (!saveResult.isSuccess()) {
                for (Database.Error error : saveResult.getErrors()) {
                    //If there are duplicates, an error occurs
                    if (error instanceof Database.DuplicateError || error.getMessage().contains('DUPLICATES_DETECTED')) {
                        System.debug('DUPLICATE');
                        Contact contact = contactList.get(i);
                        throw new TC_DealEntryWizardException('Error: New contact \'' + contact.Name + '\' already ' +
                                'exists. Please edit Deal to reuse the existing contact or enter a different contact.');
                    }
                }
            }
        }
    }

    public static void dmlInsertAccounts(List<Account> accountList) {

        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = FALSE;

        List<Database.SaveResult> saveResults = Database.insert(accountList, dml);
        for(Integer i=0; i < saveResults.size(); i++) {
            Database.SaveResult saveResult = saveResults.get(i);
            if (!saveResult.isSuccess()) {
                for (Database.Error error : saveResult.getErrors()) {
                    //If there are duplicates, an error occurs
                    if (error instanceof Database.DuplicateError || error.getMessage().contains('DUPLICATES_DETECTED')) {
                        System.debug('DUPLICATE');
                        Account acc = accountList.get(i);
                        throw new TC_DealEntryWizardException('Error: New account \'' + acc.Name + '\' already ' +
                                'exists. Please edit Deal to reuse the existing account or enter a different account');
                    }
                }
            }
        }

    }

    public static Opportunity setDealOptions() {

        Opportunity newDeal = new Opportunity();

        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=: userinfo.getProfileId() LIMIT 1];
        String profileName = PROFILE[0].Name;

        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();

        if (profileName == 'LK EF Broker') {
            newDeal.recordTypeId = recordTypeMap.get('Broker Equipment Finance').recordTypeId;
            newDeal.StageName = 'App Entry';
        } else {
            newDeal.RecordTypeId = recordTypeMap.get('Equipment Finance').recordTypeId;
            newDeal.StageName = '010 - Application Entry';
        }

        newDeal.Commencement_Date__c = System.today();

        return newDeal;

    }

    public static List<String> setCompanyRecordFilter() {

        List<String> filterList = new List<String>();
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();

        for (String recordName : recordTypeMap.keySet()) {
            if (recordName != 'Borrower') {
                filterList.add('RecordType.Name!=\'' + recordName + '\'');
            }
        }

        return filterList;
    }

    public static List<String> setPartnerRecordFilter() {

        List<String> filterList = new List<String>();
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();

        for (String recordName : recordTypeMap.keySet()) {
            if (recordName != 'Vendor') {
                filterList.add('RecordType.Name!=\'' + recordName + '\'');
            }
        }

        return filterList;
    }

    public static String retrieveCancelButtonURL() {

        TC_Deal_Entry_Wizard__mdt mdt = [SELECT Id, Cancel_URL__c FROM TC_Deal_Entry_Wizard__mdt
                                                    WHERE Label =: 'Default' LIMIT 1];

        return mdt.Cancel_URL__c;

    }

    public class TC_DealWrapper {
        @AuraEnabled
        public Opportunity deal;

        public TC_DealWrapper() {
            this.deal = setDealOptions();
        }
    }

    public class TC_CompanyWrapper {
        @AuraEnabled
        public Account company;
        @AuraEnabled
        public String[] recordFilter;
        @AuraEnabled
        public Boolean readOnly;

        public TC_CompanyWrapper() {
            this.company = null;
            this.readOnly = false;
            this.recordFilter = setCompanyRecordFilter();
        }
    }

    public class TC_GuarantorWrapper {
        @AuraEnabled
        public Relationship__c guarantor;
        @AuraEnabled
        public Boolean contactReadOnly;
        @AuraEnabled
        public Boolean accountReadOnly;

        @AuraEnabled
        public Boolean isAccountRelated;
        @AuraEnabled
        public Boolean isSelected;

        public TC_GuarantorWrapper(Relationship__c guarantor) {
            this.guarantor = guarantor;
            this.isSelected = false;
        }
    }

    public class TC_PartnerWrapper {
        @AuraEnabled
        public Account partner;
        @AuraEnabled
        public String[] recordFilter;
        @AuraEnabled
        public Boolean readOnly;

        public TC_PartnerWrapper() {
            this.partner = null;
            this.readOnly = false;
            this.recordFilter = setPartnerRecordFilter();
        }
    }

    public class TC_DealWizardWrapper {

        @AuraEnabled
        public TC_DealWrapper dealWrapper;

        @AuraEnabled
        public TC_CompanyWrapper companyWrapper;

        @AuraEnabled
        public List<TC_GuarantorWrapper> companyPguarantorList;
        @AuraEnabled
        public Integer companyPgSelected;

        @AuraEnabled
        public List<TC_GuarantorWrapper> companyCguarantorList;
        @AuraEnabled
        public Integer companyCgSelected;

        @AuraEnabled
        public List<TC_GuarantorWrapper> pguarantorList;

        @AuraEnabled
        public List<TC_GuarantorWrapper> cguarantorList;

        @AuraEnabled
        public List<Equipment__c> equipmentList;

        @AuraEnabled
        public TC_PartnerWrapper partnerWrapper;

        @AuraEnabled
        public String cancelButtonURL;

        public TC_DealWizardWrapper() {

            dealWrapper = new TC_DealWrapper();

            companyWrapper = new TC_CompanyWrapper();

            companyPguarantorList = new List<TC_GuarantorWrapper>();
            companyPgSelected = 0;
            companyCguarantorList = new List<TC_GuarantorWrapper>();
            companyCgSelected = 0;

            pguarantorList = new List<TC_GuarantorWrapper>();
            cguarantorList = new List<TC_GuarantorWrapper>();

            equipmentList = new List<Equipment__c>();

            partnerWrapper = new TC_PartnerWrapper();

            cancelButtonURL = retrieveCancelButtonURL();

        }

    }

    public class TC_DealEntryWizardException extends Exception {}
}