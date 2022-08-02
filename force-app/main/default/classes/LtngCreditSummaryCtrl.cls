/**
 * Created on 2019-02-26.
 */

public with sharing class LtngCreditSummaryCtrl {

    @AuraEnabled
    public static String initData (String oppId) {

        try {
            Map <String, Object> dataMap = new Map <String, Object> ();

            Set <FieldSetMemberWrapper> oppFieldsSet = new Set <FieldSetMemberWrapper> ();
            for (FieldSetMember fsm : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fieldSets
                .getMap().get('credit_package_application').getFields()) {
                oppFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
            }
            dataMap.put('oppFieldsSet', oppFieldsSet);

            Set <FieldSetMemberWrapper> borrowerFieldsSet = new Set <FieldSetMemberWrapper> ();
            for (FieldSetMember fsm : Schema.getGlobalDescribe().get('Account').getDescribe().fieldSets
                .getMap().get('credit_package_borrower').getFields()) {
                borrowerFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
            }
            dataMap.put('borrowerFieldsSet', borrowerFieldsSet);

            Set <FieldSetMemberWrapper> vendorFieldsSet = new Set <FieldSetMemberWrapper> ();
            for (FieldSetMember fsm : Schema.getGlobalDescribe().get('Account').getDescribe().fieldSets
                .getMap().get('credit_package_vendor').getFields()) {
                vendorFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
            }
            dataMap.put('vendorFieldsSet', vendorFieldsSet);

            Set <FieldSetMemberWrapper> decisionFieldsSet = new Set <FieldSetMemberWrapper> ();
            for (FieldSetMember fsm : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fieldSets
                .getMap().get('credit_package_credit_decision').getFields()) {
                decisionFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
            }
            dataMap.put('decisionFieldsSet', decisionFieldsSet);

            Set <FieldSetMemberWrapper> creditLenderFieldsSet = new Set <FieldSetMemberWrapper> ();
            for (FieldSetMember fsm : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fieldSets
                    .getMap().get('credit_package_credit_lender').getFields()) {
                creditLenderFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
            }
            dataMap.put('creditLenderFieldsSet', creditLenderFieldsSet);

            Set <FieldSetMemberWrapper> assetFieldsSet = new Set <FieldSetMemberWrapper> ();
            for (FieldSetMember fsm : Schema.getGlobalDescribe().get('Equipment__c').getDescribe().fieldSets
                .getMap().get('credit_package_equipment').getFields()) {
                assetFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
            }
            dataMap.put('assetFieldsSet', assetFieldsSet);

            // Retrieve related equipment and corresponding vendors
            List <Equipment__c> equipment = new List <Equipment__c> ();
            String eqQueryStr = TC_DataUtil.createSelectAllQueryString ('Equipment__c', ' Opportunity__c=:oppId LIMIT 1000', null);
            equipment = Database.query(eqQueryStr);

            dataMap.put('equipment', equipment);

            List <Account> vendors = new List <Account> ();

            if (!equipment.isEmpty()) {
                Set <Id> vendorIdSet = new Set <Id> ();

                for (Equipment__c asset : equipment) {
                    vendorIdSet.add(asset.Vendor__c);
                }

                String vendorQueryStr = TC_DataUtil.createSelectAllQueryString ('Account', ' Id IN :vendorIdSet LIMIT 1000', null);
                vendors = Database.query(vendorQueryStr);
            }

            dataMap.put('vendors', vendors);

            String oppQueryStr = TC_DataUtil.createSelectAllQueryString ('Opportunity', ' Id=:oppId LIMIT 1', null);
            Opportunity opp = Database.query(oppQueryStr);
            dataMap.put('opportunity', opp);

            // Personal Guarantor Logic: Grab Guarantors & Most Recent V-Credit Response to populate table with field sets
            // credit_package_pg_contact (Contact) & credit_package_pg_bureau (Credit Report)
            String guarQueryStr = TC_DataUtil.createSelectAllQueryString ('Relationship__c', ' Related_Opportunity__c=:oppId' +
                    ' AND Relationship_Type__c = \'Personal Guarantee\' AND Person__c != null LIMIT 1000', null);

            Map<Id, Relationship__c> personalGuarMap = new Map <Id, Relationship__c> ((List <Relationship__c>) Database.query(guarQueryStr));
            Set<Id> personalGuarContactIdSet = new Set<Id>();
            Map<Id, guarantorWrapper> guarWrapperMap = new Map<Id, guarantorWrapper>();

            for (Relationship__c rel : personalGuarMap.values()) {
                guarWrapperMap.put(rel.Person__c, new GuarantorWrapper(rel.Person__c));
                personalGuarContactIdSet.add(rel.Person__c);
            }

            Set<FieldSetMemberWrapper> guarReportFieldsSet = new Set<FieldSetMemberWrapper>();

            dataMap.put('guarantors', guarWrapperMap.values());
            dataMap.put('guarReportFieldsSet', guarReportFieldsSet);

            Set<FieldSetMemberWrapper> guarContactFieldsSet = new Set<FieldSetMemberWrapper>();
            for (FieldSetMember fsm : Schema.getGlobalDescribe().get('Contact')
                    .getDescribe().fieldSets.getMap().get('credit_package_pg_contact').getFields()) {
                guarContactFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
            }
            dataMap.put('guarContactFieldsSet', guarContactFieldsSet);

            List<DataMapRetrieveWrapper> dataMapRetrieveWrappers = new List<DataMapRetrieveWrapper>();

            // If Salesforce org has PayNet app installed, retrieved the most recent Paynet report for Opportunity's Borrower
            String paynetQueryString = 'SELECT Id FROM TamarackPI__Paynet_Credit_History_Report__c ' +
                    'WHERE TamarackPI__Account__c =: borrowerId ORDER BY CreatedDate ASC LIMIT 1';
            dataMapRetrieveWrappers.add(new DataMapRetrieveWrapper('TamarackPI__Paynet_Credit_History_Report__c'
                    , 'paynetId', 'paynetFieldsSet', paynetQueryString, 'credit_package_paynet'));

            // If Salesforce org has DnB integration, retrieved the most recent DnB report for Opportunity's Borrower
            String dnbQueryString = 'SELECT Id FROM tc_dnbdirect__DnB_Direct_Data__c ' +
                    'WHERE tc_dnbdirect__Account__c =: borrowerId ORDER BY CreatedDate DESC LIMIT 1';
            dataMapRetrieveWrappers.add(new DataMapRetrieveWrapper('tc_dnbdirect__DnB_Direct_Data__c'
                    , 'dnbId', 'dnbFieldsSet', dnbQueryString, 'credit_package_dnb'));

            for (DataMapRetrieveWrapper dmrw : dataMapRetrieveWrappers) {

                Set<String> objectFieldsSet = new Set<String>();
                Id borrowerId = opp.AccountId;
                Id recordId;

                if (Type.forName(dmrw.objectAPIName) != null && borrowerId != null) {

                    List<sObject> recordList = Database.query(dmrw.databaseQueryString);
                    if (!recordList.isEmpty()) {
                        recordId = recordList[0].Id;
                        for (FieldSetMember fsm : Schema.getGlobalDescribe().get(dmrw.objectAPIName)
                                .getDescribe().fieldSets.getMap().get(dmrw.fieldsSetName).getFields()) {
                            objectFieldsSet.add(fsm.getFieldPath());
                        }
                    }

                }
                dataMap.put(dmrw.dataMapKeyName, recordId);
                dataMap.put(dmrw.dataMapFieldsSetName, objectFieldsSet);
            }

            // If Salesforce org has Scorecard, retrieve the most recently scored record
            Set<String> scorecardFieldsSet = new Set<String>();
            Id scorecardId;

            if (Type.forName('TC_Score__Scorecard__c') != null) {

                List<sObject> scorecardList = Database.query('SELECT Id FROM TC_Score__Scorecard__c ' +
                        'WHERE TC_Score__Opportunity_Lookup__c =: oppId ORDER BY CreatedDate DESC LIMIT 1');
                if (!scorecardList.isEmpty()) {
                    scorecardId = scorecardList[0].Id;
                    for (FieldSetMember fsm : Schema.getGlobalDescribe().get('TC_Score__Scorecard__c')
                            .getDescribe().fieldSets.getMap().get('credit_package_scorecard').getFields()) {
                        scorecardFieldsSet.add(fsm.getFieldPath());
                    }
                }

            }
            dataMap.put('scorecardId', scorecardId);
            dataMap.put('scorecardFieldsSet', scorecardFieldsSet);

            Credit_Package__c settings = Credit_Package__c.getInstance();
            dataMap.put('settings', settings);

            return JSON.serialize(dataMap);
        } catch (Exception ex) {
            System.debug (ex.getStackTraceString() + ' - ' + ex.getMessage());
            throw new AuraHandledException(ex.getStackTraceString() + ' - ' + ex.getMessage());
        }
    }
    @AuraEnabled
    public static String updateSetting (String settingJson) {
        Credit_Package__c setting = (Credit_Package__c) JSON.deserialize(settingJson, Credit_Package__c.class);
        upsert setting;
        return setting.Id;
    }

    public class GuarantorWrapper {

        public Id contactId;
        public Id bureauReportId;

        public GuarantorWrapper(Id contactId) {
            this.contactId = contactId;
        }

    }

    public class FieldSetMemberWrapper {

        public String fieldPath;
        public String label;

        public FieldSetMemberWrapper(String fieldPath, String label) {
            this.fieldPath = fieldPath;
            this.label = label;
        }

    }

    public class DataMapRetrieveWrapper {

        public String objectAPIName;
        public String dataMapKeyName;
        public String dataMapFieldsSetName;
        public String databaseQueryString;
        public String fieldsSetName;

        public DataMapRetrieveWrapper(String objectAPIName, String dataMapKeyName, String dataMapFieldsSetName
                ,String databaseQueryString, String fieldsSetName) {
            this.objectAPIName = objectAPIName;
            this.dataMapKeyName = dataMapKeyName;
            this.dataMapFieldsSetName = dataMapFieldsSetName;
            this.databaseQueryString = databaseQueryString;
            this.fieldsSetName = fieldsSetName;
        }

    }

}