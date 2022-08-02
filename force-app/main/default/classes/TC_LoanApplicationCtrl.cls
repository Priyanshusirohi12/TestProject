/**
 * Created on 12/19/17.
 */

public without sharing class TC_LoanApplicationCtrl {
    @AuraEnabled
    public static String getApplicationById (String appId) {

        Opportunity opp = new Opportunity ();
        populateDefaultDealValues(opp);

        if (appId != null) {
            opp = TC_WithoutSharingDataUtility.getAllFieldsOnOpportunityByRecordId(appId, new Set <String> {
                'RecordType.Name'
            });
        }

        Account company = new Account ();
        company.BillingCountryCode = 'US';
        company.Status__c = 'Pending';

        //if (opp.AccountId != null)
        //    company = TC_DataUtility.getAllFieldsOnAccountByRecordId(opp.AccountId);

        ApplicationInfo app = new ApplicationInfo ();
        app.company = company;
        app.deal = opp;
        app.quoteOptions = app.deal.Id != null ? getQuoteOptionsByDealId(opp.Id) : new List <Quote_Option__c> ();


        System.debug('app >>>  ' + app);

        return JSON.serialize(app);
    }

    @AuraEnabled
    public static String getCompanyRecordById (String recordId, Boolean isTakedown) {
        try {
            System.debug('getCompanyRecordById ' + recordId);
            Opportunity opp = new Opportunity ();
            populateDefaultDealValues(opp);
            
            if (isTakedown) {
                opp.Related_Master_Line__c = recordId;
            }

            Account company = new Account ();
            company.BillingCountryCode = 'US';
            company.Status__c = 'Pending';
            
            Id recId = (Id) recordId;
            ApplicationInfo app = new ApplicationInfo ();
            app.deal = opp;

            if (recId.getSobjectType() == Schema.Opportunity.SObjectType) {
                recordId = [SELECT AccountId FROM Opportunity WHERE Id = :recId].AccountId;
            }
                
            if (recordId != null) {
                app.company = TC_DataUtility.getAllFieldsOnAccountByRecordId(recordId);
                app.guarantors = getGuarantorsByCompanyId(recordId);
            }
            
            return JSON.serialize(app);
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static List <ContentDocument> getFilesByParentId (String parentId) {
        try {
            Set <Id> contentDocIds = new Set <Id> ();

            for (ContentDocumentLink cdl : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parentId]) {
                contentDocIds.add (cdl.ContentDocumentId);
            }

            return [SELECT Id, Title, FileType, ContentSize, Description FROM ContentDocument WHERE Id IN :contentDocIds];
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static Account saveCompany (String companyStr) { //TO DO add try catch
        try {
            Account company = (Account) JSON.deserialize(companyStr, Account.class);
            company.AutoConvert__c = false;
            upsert company;
            return company;
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static Opportunity saveDeal (String dealString) { //TO DO add try catch
        try {
            Opportunity deal = (Opportunity) JSON.deserialize(dealString, Opportunity.class);
            populateDefaultDealValues(deal);
            upsert deal;
            return deal;
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static List <Contact> saveGuarantors (List <Contact> guarantors) { //TO DO add try catch

        if (guarantors[0].AccountId == null) {
            throw new AuraHandledException ('Please save company record first.');
        }

        try {


            List <Contact> guarantorsList = new List <Contact> ();
            guarantorsList.addAll (guarantors);
            for (Contact con: guarantorsList) {
                con.AutoConvert__c = false;
                con.SSN__c = String.isEmpty(con.SSN__c) ? '' : con.SSN__c.remove('-');
            }
            upsert guarantorsList;
            return guarantorsList;
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    private static void populateDefaultDealValues (Opportunity deal) {
        deal.Name = 'Default Name';
        deal.CloseDate = System.today();
        deal.StageName = '001 - Saved Deal';
        deal.AutoConvert__c = false;
    }

    @AuraEnabled
    public static ApplicationInfo saveEquipment (List <Equipment__c> equipment, String dealString) { //TO DO add try catch

        System.debug ('saveEquipment start');
        try {
            ApplicationInfo appInfo = new ApplicationInfo ();
            Opportunity deal = (Opportunity) JSON.deserialize(dealString, Opportunity.class);

            if (deal.AccountId == null) {
                throw new AuraHandledException ('Please save company record first.');
            }

            if (deal.Id == null) {
                populateDefaultDealValues (deal);
            }
            System.debug ('upsert deal');
            upsert deal;
            appInfo.deal = deal;
            System.debug (deal);

            List <Equipment__c> eqList = new List <Equipment__c> ();
            eqList.addAll (equipment);

            for (Equipment__c eq: eqList) {
                eq.Opportunity__c = deal.Id;
            }

            System.debug ('eqList' + eqList);

            upsert eqList;
            appInfo.equipment = eqList;

            return appInfo;
        } catch (AuraHandledException ae) {
            throw ae;
        }

        catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }


    @AuraEnabled
    public static String submitApplication (String companyString, String guarantors, List<Equipment__c> equipmentList, String dealString) { //TO DO add try catch
        System.debug('submitApplication - ' + dealString);
//        try {
            Account company = (Account) JSON.deserialize(companyString, Account.class);
            // !!! (Alex Berg) Removed reference to Paynet to ensure Paynet package isn't required dependency.
            //company.TamarackPI__Paynet_Id__c = '204565555';
            company.AutoConvert__c = true; //https://gitlab.com/tamarack/tc_accelerator2/issues/38
            upsert company;

            Id accountId;// = '0014100001MUXdh';
            Id contactId;// = '0034100001evfk8';


            List <User> users = [SELECT ContactId, Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

            if (!users.isEmpty() && users[0].ContactId != null) {
                contactId = users[0].ContactId;
                accountId = users[0].Contact.AccountId;
            }

            Opportunity deal = (Opportunity) JSON.deserialize(dealString, Opportunity.class);
            populateDefaultDealValues(deal);

            deal.Broker__c = accountId;
            deal.Broker_Sales_Rep__c = contactId;
            deal.AccountId = company.Id;
            deal.StageName = '010 - Application Entry';
            deal.AutoConvert__c = true; //https://gitlab.com/tamarack/tc_accelerator2/issues/38
            deal.Name = company.Name + ' - ' + equipmentList[0].Name;

            List <Contact> guarantorsList = new List <Contact> ();
            guarantorsList.addAll((List<Contact>) JSON.deserialize(guarantors, List<Contact>.class));

            for (Contact g : guarantorsList) {
                g.AccountId = company.Id;
                g.Autoconvert__c = true; //https://gitlab.com/tamarack/tc_accelerator2/issues/38
                g.SSN__c = String.isEmpty(g.SSN__c) ? '' : g.SSN__c.remove('-');
                //if (g.Guarantor_Ownership__c != null)
                //    g.Guarantor_Ownership__c /= 100;
            }

            if (guarantorsList.size() > 0) {
                upsert guarantorsList;
                deal.Personal_Guarantor__c = guarantorsList[0].Id;
            }

            upsert deal;

            List <Relationship__c> rels = new List <Relationship__c> ();

            for (Contact g : guarantorsList)
                rels.add(new Relationship__c (Person__c = g.Id, Related_Opportunity__c = deal.Id, Percent_of_Ownership__c = g.Guarantor_Ownership__c));

            if (rels.size() > 0)
                insert rels;

            for (Equipment__c e : equipmentList)
                e.Opportunity__c = deal.Id;

            List <Equipment__c> eqList = new List <Equipment__c> ();
            eqList.addAll (equipmentList);

            for (Equipment__c eq: eqList) {
                eq.Opportunity__c = deal.Id;
            }

            if (eqList.size() > 0)
                upsert eqList;

            return 'SUCCESS';
//        } catch (Exception ex) {
//            throw new AuraHandledException (ex.getMessage());
//        }
    }

    @AuraEnabled
    public static List <Contact> getGuarantorsByCompanyId (String companyId) {
        String q = TC_DataUtility.createSelectAllQueryString('Contact', 'AccountId = :companyId AND Is_Guarantor__c = true', new Set <String> ());
        return (List <Contact>) Database.query(q);
    }

    @AuraEnabled
    public static List <Quote_Option__c> getQuoteOptionsByDealId (String dealId) {
        String q = TC_DataUtility.createSelectAllQueryString('Quote_Option__c', 'Opportunity__c = :dealId', new Set <String> {
            'RecordType.Name'
        });
        return (List <Quote_Option__c>) Database.query(q);
    }

    @AuraEnabled
    public static Account selectCompany (String companyId) {
        try {
            return TC_DataUtility.getAllFieldsOnAccountByRecordId(companyId);
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static Contact selectGuarantor (String guarantorId) {
        try {
            return TC_DataUtility.getAllFieldsOnContactByRecordId(guarantorId);
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean setIsMasterLine (String recordId) {
        try {
            System.debug('setIsMasterLine ' + recordId);
            return [SELECT Master_Line_Opportunity__c FROM Opportunity WHERE Id = :recordId].Master_Line_Opportunity__c;
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static String getMasterLine (String masterLineId) {
        try {
            System.debug('getMasterLine ' + masterLineId);
            return [SELECT Name FROM Opportunity WHERE Id = :masterLineId].Name;
        } catch (Exception ex) {
            throw new AuraHandledException (ex.getMessage());
        }
    }

    @AuraEnabled
    public static PicklistInfo getDependentPicklists () {
        Equipment__c e = new Equipment__c();
        // Get the object type of the SObject.
        Schema.sObjectType objType = e.getSObjectType ();
 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe ();
        
        // Get a map of fields for the SObject
        Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap ();
        
        PicklistInfo pi = new PicklistInfo ();
        
        pi.seriesPicklistMap = getDependentPicklist(fieldMap, 'Series_Picklist__c', 'Make_Picklist__c');
        pi.modelPicklistMap = getDependentPicklist(fieldMap, 'Model_Picklist__c', 'Series_Picklist__c');
        pi.enginePicklistMap = getDependentPicklist(fieldMap, 'Engine_Picklist__c', 'Series_Picklist__c');
        
        return pi;
    }

    @AuraEnabled
    public static List <String> getPicklistVals (String picklistMapString, String contrValue) {
        List <String> allOpts = ((Map<String, List<String>>) JSON.deserialize(picklistMapString, Map<String, List<String>>.class)).get(contrValue);
        allOpts.sort();
        return allOpts;
    }

    public static Map<String, List<String>> getDependentPicklist (Map <String, Schema.SObjectField> fieldMap, String depFld, String contrFld) {
        // Get the list of picklist values for this field.
        List <Schema.PicklistEntry> values = fieldMap.get(depFld).getDescribe().getPickListValues();
        
        // validFor property cannot be accessed via a method or a property,
        // so we need to serialize the PicklistEntry object and then deserialize into a wrapper.
        List<Schema.PicklistEntry> contrEntries = fieldMap.get(contrFld).getDescribe().getPicklistValues();
        List<TC_GetPicklistOptionsCtrl.PicklistEntryWrapper> depEntries = TC_GetPicklistOptionsCtrl.wrapPicklistEntries(values);
        
        // Set up the return container - Map<ControllingValue, List<DependentValues>>
        Map<String, List<String>> objResults = new Map<String, List<String>>();
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (TC_GetPicklistOptionsCtrl.PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = TC_GetPicklistOptionsCtrl.base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                // For each bit, in order: if it's a 1, add this label to the dependent list for the corresponding controlling value
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(plew.value);
                }
            }
        }
        
        return objResults;
    }

    public class ApplicationInfo {
        @AuraEnabled
        public Account company { get; set; }

        @AuraEnabled
        public Opportunity deal { get; set; }

        @AuraEnabled
        public List <Equipment__c> equipment { get; set; }
        @AuraEnabled
        public List <Contact> guarantors { get; set; }
        @AuraEnabled
        public List <Quote_Option__c> quoteOptions {get; set;}

        public ApplicationInfo () {
            company = new Account();
            deal = new Opportunity();
            equipment = new List <Equipment__c> ();
        }

    }

    public class PicklistInfo {
        @AuraEnabled
        public Map<String, List<String>> seriesPicklistMap { get; set; }

        @AuraEnabled
        public Map<String, List<String>> modelPicklistMap { get; set; }

        @AuraEnabled
        public Map<String, List<String>> enginePicklistMap { get; set; }
    }
}