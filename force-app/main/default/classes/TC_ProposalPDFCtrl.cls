/**
 * Created by tamarack on 12/30/19.
 */

public with sharing class TC_ProposalPDFCtrl {

    @AuraEnabled
    public static docWrapper grabDocWrapper(Id recordId) {

        docWrapper docWrapper = new docWrapper();

        // Query to determine single or multi-tenant environment
        Id userId = UserInfo.getUserId();
        List<User> users = new List<User>([SELECT Id, Account.Id FROM User WHERE Id =: userId]);
        Id accountId = (!users.isEmpty()) ? users[0].Account.Id : null;
        docWrapper.logoURL = TC_RetrieveAccountLogo.retrieve(accountId, null);

        // Query to get Opportunity and Opportunity's Account
        List<Opportunity> opportunities = new List<Opportunity>([
                SELECT Id, AccountId, Account.Name, Account.Primary_Contact__r.Name, Account.Phone
                        , Account.BillingStreet, Account.BillingCity, Account.BillingCountry
                        , Account.BillingState, Account.BillingPostalCode
                FROM Opportunity
                WHERE Id =: recordId
        ]);
        docWrapper.opportunity = opportunities[0];

        // Query to get Equipment, Quote Options
        List<DataMapRetrieveWrapper> dataMapRetrieveWrappers = new List<DataMapRetrieveWrapper>();

        String equipmentQueryString = 'SELECT Id FROM Equipment__c WHERE Opportunity__c = \'' + recordId + '\'';
        dataMapRetrieveWrappers.add(new DataMapRetrieveWrapper('Equipment__c', 'Equipment Details'
                , 'equipmentInfo', 'proposalPDF_Equipment', equipmentQueryString));

        String quoteOptionQueryString = 'SELECT Id FROM Quote_Option__c WHERE Opportunity__c = \'' + recordId + '\'';
        dataMapRetrieveWrappers.add(new DataMapRetrieveWrapper('Quote_Option__c', 'Quote Options'
                , 'quoteOptionInfo', 'proposalPDF_QuoteOption', quoteOptionQueryString));

        for (DataMapRetrieveWrapper dmrw : dataMapRetrieveWrappers) {

            List<FieldSetMemberWrapper> objectFieldsSet = new List<FieldSetMemberWrapper>();

            if (Type.forName(dmrw.objectAPIName) != null) {

                List<sObject> recordList = Database.query(dmrw.databaseQueryString);
                if (!recordList.isEmpty()) {
                    recordId = recordList[0].Id;
                    for (FieldSetMember fsm : Schema.getGlobalDescribe().get(dmrw.objectAPIName)
                            .getDescribe().fieldSets.getMap().get(dmrw.docWrapperFieldsSetName).getFields()) {
                        objectFieldsSet.add(new FieldSetMemberWrapper(fsm.getFieldPath(), fsm.getLabel()));
                    }
                    docWrapper.tableWrapperList.add(new tableWrapper(dmrw.tableLabel, dmrw.objectAPIName, recordList, objectFieldsSet));
                }

            }

        }

        return docWrapper;

    }

    public class docWrapper {

        @AuraEnabled
        public String logoURL;
        @AuraEnabled
        public Opportunity opportunity;
        @AuraEnabled
        public List<tableWrapper> tableWrapperList;
        @AuraEnabled
        public Date currentDate;

        public docWrapper() {
            this.tableWrapperList = new List<tableWrapper>();
            this.currentDate = System.today();
        }

    }

    public class tableWrapper {

        @AuraEnabled
        public String tableLabel;
        @AuraEnabled
        public String objectAPIName;
        @AuraEnabled
        public List<sObject> objectRecordList;
        @AuraEnabled
        public List<FieldSetMemberWrapper> fieldSetList;

        public tableWrapper(String tableLabel, String objectAPIName, List<sObject> objectRecordList
                , List<FieldSetMemberWrapper> fieldSetList) {
            this.tableLabel = tableLabel;
            this.objectAPIName = objectAPIName;
            this.objectRecordList = objectRecordList;
            this.fieldSetList = fieldSetList;
        }

    }

    public class FieldSetMemberWrapper {

        @AuraEnabled
        public String fieldPath;
        @AuraEnabled
        public String label;

        public FieldSetMemberWrapper(String fieldPath, String label) {
            this.fieldPath = fieldPath;
            this.label = label;
        }

    }

    public class DataMapRetrieveWrapper {

        public String objectAPIName;
        public String docWrapperkey;
        public String docWrapperFieldsSetName;
        public String databaseQueryString;
        public String tableLabel;

        public DataMapRetrieveWrapper(String objectAPIName, String tableLabel,
                String docWrapperkey, String docWrapperFieldsSetName,String databaseQueryString) {
            this.objectAPIName = objectAPIName;
            this.tableLabel = tableLabel;
            this.docWrapperkey = docWrapperkey;
            this.docWrapperFieldsSetName = docWrapperFieldsSetName;
            this.databaseQueryString = databaseQueryString;
        }

    }

}