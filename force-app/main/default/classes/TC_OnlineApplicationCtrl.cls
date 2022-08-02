/**
 * Created on 11/8/18.
 */

public without sharing class TC_OnlineApplicationCtrl {

    // Online Application Set-up
    @AuraEnabled public String partnerCode { get; set; }
    @AuraEnabled public String leadId { get; set; }
    @AuraEnabled public String vendorId { get; set; }
    @AuraEnabled public String logoURL { get; set; }
    @AuraEnabled public String headerColor {get; set;}
    @AuraEnabled public String disclosureText { get; set; }
    @AuraEnabled public Boolean useGoogleAddressApi {get; set;}
    @AuraEnabled public Id queueGroupId { get; set; }
    @AuraEnabled public Id currentUserId { get; set; }
    @AuraEnabled public List<String> warningMessageList { get; set; }

    // Record creation & uploaded files
    @AuraEnabled public SectionWrapper businessSectionWrapper { get; set; }
    @AuraEnabled public SectionWrapper primaryContactSectionWrapper { get; set; }
    @AuraEnabled public SectionWrapper primaryContactGuarSectionWrapper { get; set; }
    @AuraEnabled public List<SectionWrapper> guarantorSectionWrapperList { get; set; }
    @AuraEnabled public List<SectionWrapper> equipmentSectionWrapperList { get; set; }
    //@AuraEnabled public QuoteWrapper quoteSectionWrapper { get; set; }
    @AuraEnabled public List<ContentDocument> filesList;

    // Used in Aura Component for easy insertion of guarantors & equipment
    @AuraEnabled public SectionWrapper guarantorSectionWrapperTemplate { get; set; }
    @AuraEnabled public SectionWrapper equipmentSectionWrapperTemplate { get; set; }

    // Used to set Address Mappings. For guarantor & equipments, integers are replaced with '2/3/4' dynamically.
    @AuraEnabled
    public Map<String, List<addressObject>> addressMappingMap {
        get {
            return addressMappingMap;
        } set {
            this.addressMappingMap = new Map<String, List<addressObject>>{
                    'business' => new List<addressObject>{
                            new addressObject('Street', 'Street')
                            , new addressObject('City', 'City')
                            , new addressObject('StateCode', 'StateCode')
                            , new addressObject('PostalCode', 'PostalCode')
                            , new addressObject('CountryCode', 'CountryCode')
                    },
                    'primaryContactGuar' => new List<addressObject>{
                            new addressObject('Street', 'Contact_Street_1__c')
                            , new addressObject('City', 'Contact_City_1__c')
                            , new addressObject('StateCode', 'Contact_State_1__c')
                            , new addressObject('PostalCode', 'Contact_Postal_Code_1__c')
                            , new addressObject('CountryCode', 'Contact_Country_1__c')
                    },
                    'guarantor' => new List<addressObject>{
                            new addressObject('Street', 'Contact_Street_2__c')
                            , new addressObject('City', 'Contact_City_2__c')
                            , new addressObject('StateCode', 'Contact_State_2__c')
                            , new addressObject('PostalCode', 'Contact_Postal_Code_2__c')
                            , new addressObject('CountryCode', 'Contact_Country_2__c')
                    },
                    'equipment' => new List<addressObject>{
                            new addressObject('Street', 'Equipment_1_Address__c')
                            , new addressObject('City', 'Equipment_1_City__c')
                            , new addressObject('StateCode', 'Equipment_1_State__c')
                            , new addressObject('PostalCode', 'Equipment_1_Postal_Code__c')
                            , new addressObject('CountryCode', 'Equipment_1_Country__c')
                    }
            };
        }
    }

    public class addressObject {
        public String standardAddressField;
        public String sectionAddressField;
        public addressObject(String standardAddressField, String sectionAddressField) {
            this.standardAddressField = standardAddressField;
            this.sectionAddressField = sectionAddressField;
        }
        public addressObject() {}
    }


    // Used for storing Data information for Quote Option section
    /*public class DataTableColumn {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String fieldName { get; set; }
        @AuraEnabled public String type { get; set; }
        public DataTableColumn(AuraFieldDescription afd) {
            this.label = afd.fieldLabel;
            this.fieldName = afd.fieldName;
            this.type = afd.formInputType;
            if (afd.fieldType == 'DATE') this.type = 'date-local';
            if (afd.fieldType == 'DATETIME') this.type = 'date';
        }
        public DataTableColumn() {}
    }

    public class QuoteWrapper {
        @AuraEnabled public List<DataTableColumn> dataTableColumnList { get; set; }
        @AuraEnabled public List<Quote_Option__c> quoteOptionList { get; set; }
        @AuraEnabled public Id selectedQuoteOptionId { get; set; }
        public QuoteWrapper(List<DataTableColumn> dataTableColumnList, List<Quote_Option__c> quoteOptionList
                , Id selectedQuoteOptionId) {
            this.dataTableColumnList = dataTableColumnList;
            this.quoteOptionList = quoteOptionList;
            this.selectedQuoteOptionId = selectedQuoteOptionId;
        }
        public QuoteWrapper() {}
    }*/

    // Section Wrapper for each portion of Online Application
    public class SectionWrapper {
        @AuraEnabled public Map<String, List<AuraFieldDescription>> sectionFields { get; set; }
        public Map<String, FieldSet> sectionFieldSets {get; set; }
        @AuraEnabled public List<String> sectionHeaders { get; set; }
        @AuraEnabled public Lead sObjectRecord { get; set; }
        @AuraEnabled public Boolean addressBoolean { get; set; }
        @AuraEnabled public Boolean requireAddressBoolean {get; set;}
        @AuraEnabled public Map<String, List<String>> countryStatesMap;
        @AuraEnabled public List<Map<String, String>> countryCodeList;
        @AuraEnabled public Boolean existBoolean { get; set; }
        public SectionWrapper(Map<String, List<AuraFieldDescription>> sectionFields
                , List<String> sectionHeaders, Lead sObjectRecord, Boolean addressBoolean
                , Map<String, List<String>> countryStatesMap, List<Map<String, String>> countryCodeList) {
            this.sectionFields = sectionFields;
            this.sectionHeaders = sectionHeaders;
            this.sObjectRecord = sObjectRecord;
            this.addressBoolean = addressBoolean;
            this.countryStatesMap = countryStatesMap;
            this.countryCodeList = countryCodeList;
            this.requireAddressBoolean = true;
        }
        public SectionWrapper(Map<String, List<AuraFieldDescription>> sectionFields
                , List<String> sectionHeaders, Lead sObjectRecord, Boolean addressBoolean
                , Map<String, List<String>> countryStatesMap, List<Map<String, String>> countryCodeList, Boolean existBoolean) {
            this.sectionFields = sectionFields;
            this.sectionHeaders = sectionHeaders;
            this.sObjectRecord = sObjectRecord;
            this.addressBoolean = addressBoolean;
            this.countryStatesMap = countryStatesMap;
            this.countryCodeList = countryCodeList;
            this.existBoolean = existBoolean;
            this.requireAddressBoolean = true;
        }
        public SectionWrapper(Map<String, List<AuraFieldDescription>> sectionFields
                , List<String> sectionHeaders, Lead sObjectRecord, Boolean addressBoolean
                , Map<String, List<String>> countryStatesMap, List<Map<String, String>> countryCodeList, Boolean existBoolean, Boolean requireAddressBoolean) {
            this.sectionFields = sectionFields;
            this.sectionHeaders = sectionHeaders;
            this.sObjectRecord = sObjectRecord;
            this.addressBoolean = addressBoolean;
            this.countryStatesMap = countryStatesMap;
            this.countryCodeList = countryCodeList;
            this.existBoolean = existBoolean;
            this.requireAddressBoolean = requireAddressBoolean;
        }
        public SectionWrapper() {}
    }

    public TC_OnlineApplicationCtrl() {
        this.addressMappingMap = addressMappingMap;
    }

    @AuraEnabled
    public static TC_OnlineApplicationCtrl doApplicationInit(String partnerCode, String vendorId, String leadId, String urlParameters) {

        try {
            TC_OnlineApplicationCtrl wrapper = new TC_OnlineApplicationCtrl();
            wrapper.leadId = leadId;
            wrapper.currentUserId = UserInfo.getUserId();
            wrapper.filesList = new List<ContentDocument>();
            wrapper.warningMessageList = new List<String>();
            wrapper.partnerCode = partnerCode != '' ? partnerCode : TC_OnlineApplicationInitCtrl.getSingleTenantCode();
            wrapper.logoURL = TC_RetrieveAccountLogo.retrieve(wrapper.partnerCode, vendorId);
            wrapper.headerColor = TC_RetrieveAccountLogo.retrieveHeaderBackgroundColor(wrapper.partnerCode, wrapper.vendorId);
            wrapper.vendorId = vendorId;

            TC_OnlineApplicationInitCtrl.getApplicationProgram(wrapper);
            TC_OnlineApplicationInitCtrl.getAppSettingInformation(wrapper);
            TC_OnlineApplicationInitCtrl.getStateCountryPicklistInformation(wrapper);
            TC_OnlineApplicationInitCtrl.getLeadInformation(urlParameters, wrapper);
            //TC_OnlineApplicationInitCtrl.getQuoteInformation(wrapper);
            System.debug('TC_OnlineApplicationCtrl - init wrapper: ' + wrapper);
            return wrapper;
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            //throw new AuraHandledException(ex.getMessage());
            return null;
        }

    }

    @AuraEnabled
    public static TC_OnlineApplicationCtrl submitCommercialApplication(String wrapperString) {

        try {
            TC_OnlineApplicationCtrl wrapper = (TC_OnlineApplicationCtrl) JSON.deserialize(wrapperString, TC_OnlineApplicationCtrl.class);
            TC_OnlineApplicationSubmitCtrl.createLead(wrapper);
            TC_OnlineApplicationSubmitCtrl.attachGuestFileUploads(wrapper);
            return wrapper;
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }

    }

    @AuraEnabled
    public static String submitFollowUp(String wrapperString) {

        try {
            TC_OnlineApplicationCtrl wrapper = (TC_OnlineApplicationCtrl) JSON.deserialize(wrapperString, TC_OnlineApplicationCtrl.class);
            String warningString = TC_OnlineApplicationSubmitCtrl.submitFollowUp(wrapper);
            return warningString;
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }

    }

    @AuraEnabled
    public static List<ContentDocument> getFiles(String recordId) {

        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>();
        List<ContentDocumentLink> cdl= new List<ContentDocumentLink>([
                SELECT Id, LinkedEntityId, ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN: recordIds
                ORDER BY SystemModstamp DESC LIMIT 1
        ]);
        for(ContentDocumentLink cdLink:cdl){
            documentIds.add(cdLink.ContentDocumentId);
        }
        return [SELECT Id,Title,FileType FROM ContentDocument WHERE id IN: documentIds];

    }

    @AuraEnabled
    public static void deleteFiles(String cdId) {

        try {
            List <Guest_File_Upload__e> fileEvents = new List <Guest_File_Upload__e> {
                    new Guest_File_Upload__e (Action__c = 'DELETE', Document_Id__c = cdId)
            };
            List<Database.SaveResult> results = EventBus.publish(fileEvents);
        } catch (Exception ex) {
            System.debug(ex);
            throw new AuraHandledException(ex.getMessage());
        }

    }

    public class TC_OnlineApplicationCtrlException extends Exception {}

}