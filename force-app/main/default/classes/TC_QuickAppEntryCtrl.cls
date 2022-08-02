public with sharing class TC_QuickAppEntryCtrl {
    
    public Opportunity opp {get; set;}
    public Contact con {get; set;}
    public Account acc {get; set;}
    public Account addEditVendor {get; set;}
    public Contact addEditGuarCon {get; set;}
    public Reference__c addEditRef {get; set;}
    public Equipment__c addEditEq {get; set;}
    public String ssnSearchText {get; set;}
    public List <Contact> personalGuarantors {get; set;}
    public List <Equipment__c> equipmentList {get; set;}
    public List <Reference__c> references {get; set;}
    public String selectedAccountId {get; set;}
    public String selectedVendorId {get; set;}
    
    private Id borrowerRtId;
    private Id vendorRtId;
    
    public TC_QuickAppEntryCtrl () {
        try {
            Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
            borrowerRtId = d.getRecordTypeInfosByName().get('Borrower').getRecordTypeId();
            vendorRtId = d.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
            String oppId = ApexPages.currentPage().getParameters().get('Id');
            addEditGuarCon = new Contact();
            addEditEq = new Equipment__c();
            addEditVendor = new Account ();
            addEditRef = new Reference__c ();
            
            if (String.isEmpty(oppId)) {
                acc = new Account ();
                con = new Contact ();
                
                opp = new Opportunity();
            } else {
                oppId = String.escapeSingleQuotes(oppId);
                String oppQuery = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Opportunity', 'quickapp_dealdetails', new Set <String> {'AccountId'});
                oppQuery += ' WHERE Id = \'' + oppId + '\'';
                
                opp = Database.query (oppQuery);
                
                String accountQuery = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Account', 'quickapp_companyinfo', new Set <String> {'AccountNumber'});
                accountQuery += ' WHERE Id = \'' + opp.AccountId + '\'';
                
                acc = Database.query (accountQuery);
                getPersonalGuarantors();
                getEquipmentList();
                getReferences();
            }

            
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            System.debug(ex);
        }      
    }
    
    public PageReference selectAccount () {
        
        try {
            String accountQuery = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Account', 'quickapp_companyinfo', new Set <String> {'AccountNumber'});
            accountQuery += ' WHERE Id = \'' + selectedAccountId + '\'';
        
        	acc = Database.query (accountQuery);
            
            System.debug ('>>> selected account - ' + acc);
            
        } catch (Exception ex) {
            System.debug(ex);
            ApexPages.addMessages (ex);
        }
        
        
        return null;
    }
    
    public PageReference selectVendor () {
        
        try {
            String accountQuery = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Account', 'quickapp_edit_vendor', new Set <String> {'AccountNumber'});
            accountQuery += ' WHERE Id = \'' + selectedVendorId + '\'';
        
        	addEditVendor = Database.query (accountQuery);
            
            System.debug ('>>> selected account - ' + addEditVendor);
            
        } catch (Exception ex) {
            System.debug(ex);
            ApexPages.addMessages (ex);
        }
        
        
        return null;
    }
	
    public String selectedGuarantorId {get; set;}
	public PageReference selectGuarantor () {
        
        try {
            String guarQuery = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Contact', 'quickapp_edit_guarantor', new Set <String> {'Id'});
            guarQuery += ' WHERE Id = \'' + selectedGuarantorId + '\'';
        
        	addEditGuarCon = Database.query (guarQuery);
            
            System.debug ('>>> selected guarantor - ' + addEditGuarCon);
            
        } catch (Exception ex) {
            System.debug(ex);
            ApexPages.addMessages (ex);
        }
        
        
        return null;
    }

    
    public PageReference saveDeal () {
        
        try {
            acc.RecordTypeId = borrowerRtId;
            upsert acc;
            opp.AccountId = acc.Id;
            upsert opp;
            //con.AccountId = acc.Id;
            //upsert con;
            
            
        } catch (Exception ex) {
            System.debug(ex);
            ApexPages.addMessages (ex);
        }
        return null;
    }
    
    public List <Contact> getPersonalGuarantors () {
        personalGuarantors = new List <Contact> ();
        
        String query = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Contact', 'quickapp_relatedlist_guarantor');
        query += ' WHERE AccountId = \'' + acc.Id +'\' AND Is_Guarantor__c = true   LIMIT 1000';
        personalGuarantors = Database.query(query);
        System.debug (personalGuarantors);
        return personalGuarantors;
    }
    
    public List <Reference__c> getReferences () {
        references = new List <Reference__c> ();
        
        String query = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Reference__c', 'quickapp_relatedlist_reference');
        query += ' WHERE Opportunity__c = \'' + opp.Id +'\'  LIMIT 1000';
        references = Database.query(query);
        System.debug (references);
        return references;
    }
    
    public List <Equipment__c> getEquipmentList () {
        equipmentList = new List <Equipment__c> ();
        
        String query = TC_QuickAppDataUtility.createQueryStringFromFieldSet('Equipment__c', 'quickapp_relatedlist_equipment');
        query += ' WHERE Opportunity__c = \'' + opp.Id +'\' LIMIT 1000';
        System.debug ('Equipment query string -  ' + query);
        equipmentList = Database.query(query);
        System.debug (equipmentList);
        return equipmentList;
    }

    
    
    public String saveContactGuarErr {get; set;}
    public void saveContactGuar () {
        saveContactGuarErr = '';
        try {
            
            if (addEditGuarCon.AccountId != null && addEditGuarCon.AccountId != acc.Id)
            	addEditGuarCon = addEditGuarCon.clone(false,true,false,false); //need to copy that one to current account
            
            
            addEditGuarCon.AccountId = acc.Id;
            addEditGuarCon.Is_Guarantor__c = true;
            upsert addEditGuarCon;
            OpportunityContactRole ocr = new OpportunityContactRole ();
            ocr.ContactId = addEditGuarCon.Id;
            ocr.OpportunityId = opp.Id;
            ocr.Role = 'Guarantor'; 
            insert ocr;
            addEditGuarCon = new Contact ();
            getPersonalGuarantors ();
        } catch (Exception ex) {
            System.debug (ex);
            saveContactGuarErr = 'Error while saving record - ' + ex.getMessage();
        }
    }
    
    public String saveRefErr {get; set;}
    public void saveReferenceRecord () {
        saveRefErr = '';
        try {
            addEditRef.Opportunity__c = opp.Id;
            upsert addEditRef;
            addEditRef = new Reference__c();
            getReferences();
        } catch (Exception ex) {
            System.debug (ex);
            saveRefErr = 'Error while saving record - ' + ex.getMessage();
        }
    }
    
    public String saveEquipErr {get; set;}
    public void saveEquipment () {
        
        saveEquipErr = '';
        try {
            addEditEq.Opportunity__c = opp.Id;
           
            upsert addEditEq;
            
            addEditEq = new Equipment__c ();
            getEquipmentList();
            
        } catch (Exception ex) {
            System.debug (ex);
            saveEquipErr = 'Error while saving record - ' + ex.getMessage();
        }
    }
    
    public String saveVendorErr {get; set;}
    public String selectedEquipmentId {get; set;}
    public void saveVendor () {
 		System.debug ('Saving vendor to eq ' + addEditVendor);
        System.debug ('Saving eq id ' + selectedEquipmentId);     
        saveVendorErr = '';
        try {
            
           	addEditVendor.RecordTypeId = vendorRtId;
            upsert addEditVendor;
            Equipment__c eq = new Equipment__c (Id=selectedEquipmentId);
            eq.Vendor__c = addEditVendor.Id;
            update eq;
            
            addEditVendor = new Account ();
            getEquipmentList();
            
        } catch (Exception ex) {
            System.debug (ex);
            saveVendorErr = 'Error while saving record - ' + ex.getMessage();
        }
    }
    
    
    @RemoteAction
    public static List <Account> doSSNSearch (String searchText) {
        
        Set <String> fieldsToReturn = TC_QuickAppDataUtility.parseFieldSet('Account', 'quickapp_ssnsearchresults');
        fieldsToReturn.add('Id');
        String soslQuery = 'FIND :searchText IN ALL FIELDS RETURNING Account (';
        
        for (String s: fieldsToReturn) {
            
            soslQuery += s +',';
        }
        
        soslQuery = soslQuery.removeEnd(',') + ' WHERE RecordType.DeveloperName = \'Borrower\')';
        System.debug(soslQuery);
        List<List<SObject>> searchList = Search.query(soslQuery);
        return (List <Account>) searchList[0];
    }
    
    @RemoteAction
    public static List <Account> doVendorSearch (String searchText) {
        
        Set <String> fieldsToReturn = TC_QuickAppDataUtility.parseFieldSet('Account', 'quickapp_vendorsearchresults');
        fieldsToReturn.add('Id');
        String soslQuery = 'FIND :searchText IN ALL FIELDS RETURNING Account (';
        
        for (String s: fieldsToReturn) {
            
            soslQuery += s +',';
        }
        
        soslQuery = soslQuery.removeEnd(',') + ' WHERE RecordType.DeveloperName = \'Vendor\')';
        System.debug(soslQuery);
        List<List<SObject>> searchList = Search.query(soslQuery);
        return (List <Account>) searchList[0];
    }
    
    @RemoteAction
    public static List <Contact> doGuarSearch (String searchText) {
        
        Set <String> fieldsToReturn = TC_QuickAppDataUtility.parseFieldSet('Contact', 'quickapp_relatedlist_guarantor');
        fieldsToReturn.add('Id');
        String soslQuery = 'FIND :searchText IN ALL FIELDS RETURNING Contact (';
        
        for (String s: fieldsToReturn) {
            
            soslQuery += s +',';
        }
        
        soslQuery = soslQuery.removeEnd(',') + ' WHERE Is_Guarantor__c = true)';
        System.debug(soslQuery);
        List<List<SObject>> searchList = Search.query(soslQuery);
        return (List <Contact>) searchList[0];
    }
}