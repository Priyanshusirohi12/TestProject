public with sharing class TC_DocRequestFormCtrlLtng {

    @auraEnabled
    public static docWrapper grabDocWrapper(ID recordId) {

        // Query to get relevant client LK EF Lender Account
        Account client;
        Id userId = UserInfo.getUserId();
        List<User> users = new List<User>([SELECT Id,Account.Id
        FROM User WHERE Id =: userId]);

        String accountNumber = (!users.isEmpty()) ? users[0].Account.Id : null;
        String logoURL = TC_RetrieveAccountLogo.retrieve(accountNumber, null);

        // Query to get relevant details from Opportunity
        List<Opportunity> opportunities = new List<Opportunity>([SELECT ID,(SELECT ID,Name,Approved_Rate__c
                ,Doc_Fee__c
                ,Application_Number__c
                ,Funding_Source__r.Name
                ,Commission__c
                ,Broker_Doc_Fee__c
                ,Source_Doc_Fee__c
                ,Total_Doc_Fees__c
        FROM Funding_Sources__r
        WHERE Selected__c = True)
                ,(SELECT Id,Relationship_Type__c, RecordType.Name
                ,Person__r.Name
                ,Person__r.Phone
                ,Person__r.Email
                ,Person__r.MailingStreet
                ,Person__r.MailingCity
                ,Person__r.MailingState
                ,Person__r.MailingPostalCode
                ,Business__r.Name, Signer__c
        FROM Relationships_Opportunity__r)
                ,(SELECT ID,Vendor_Name__c, Vendor__c
                ,Quantity__c,Name
                ,Serial_Numbers__c
                ,Cost_Per_Unit__c, Vendor_Information__c
                ,Vendor__r.Phone, Vendor__r.Company_Email__c
        FROM Opportunity_Assets__r)
                ,(SELECT Fee_Type__c, Amount__c FROM Fees__r)
                ,Name,Account.Id,Total_Finance_Amount__c
                ,Upfront_Tax_Financed__c,Other_Upfront_Financed__c
                ,Total_Equipment_Cost__c,Upfront_Taxes__c
                ,Term__c,Number_of_Advance_Payments__c,Advanced_Amount_Calculated__c
                ,Total_Prefund_Interest__c,Funding_Instructions__c
                ,Security_Deposit__c,Down_Payment__c
                ,Payment_Structure_Rich__c,Product__c,Misc_Doc_Instructions__c
                ,Approved_Rate__c,Total_Payment__c
        FROM Opportunity
        WHERE ID=:recordId]);

        Opportunity opp;
        Funding_Source__c fundingSource;
        Account account;
        List<Relationship__c> relationships;
        Decimal totalFeeDue = 0;

        if (!opportunities.isEmpty()) {
            opp = opportunities[0];
            opp.Upfront_Taxes__c = (opp.Upfront_Taxes__c == null) ? 0 : opp.Upfront_Taxes__c;
            opp.Upfront_Tax_Financed__c = (opp.Upfront_Tax_Financed__c == null) ? 0 : opp.Upfront_Tax_Financed__c;
            opp.Other_Upfront_Financed__c = (opp.Other_Upfront_Financed__c == null) ? 0 : opp.Other_Upfront_Financed__c;
            opp.Security_Deposit__c =  (opp.Security_Deposit__c == null) ? 0 : opp.Security_Deposit__c;
            opp.Down_Payment__c =  (opp.Down_Payment__c == null) ? 0 : opp.Down_Payment__c;

            for (Fee__c fee : opp.Fees__r) {
                totalFeeDue = (fee.Amount__c != null) ? totalFeeDue + fee.Amount__c : totalFeeDue;
            }

            try {
                fundingSource = opp.Funding_Sources__r[0];
            } catch (Exception e) {
                // No selected funding source available
            }

            try {
                relationships = opp.Relationships_Opportunity__r;
            } catch (Exception e) {
                // No signors available
            }

            List<Account> accounts = new List<Account>([SELECT ID, Name, DBA__c, Fed_Tax_ID__c,
                    BillingStreet, BillingCity, BillingState, BillingCountry,
                    BillingPostalCode, Primary_Contact__r.Name,
                    Primary_Contact__r.Phone, ShippingStreet, ShippingCity,
                    ShippingState, ShippingCountry, ShippingPostalCode
            FROM Account
            WHERE ID =: opp.AccountId]);
            if (!accounts.isEmpty()) {
                account = accounts[0];
            }

        }

        List<Relationship__c> principalContacts = new List<Relationship__c>();
        List<Relationship__c> otherContacts = new List<Relationship__c>();
        List<Relationship__c> corpGuarantors = new List<Relationship__c>();
        if (!relationships.isEmpty()) {
            for (Relationship__c r : relationships) {
                if (r.RecordType.Name == 'Individual' && r.Relationship_Type__c == 'Principal' && r.Signer__c == true) {
                    principalContacts.add(r);
                }
                else if (r.RecordType.Name == 'Individual' && r.Signer__c == true) {
                    otherContacts.add(r);
                } else if (r.RecordType.Name == 'Corporation') {
                    corpGuarantors.add(r);
                }
            }
        }
        return new docWrapper(opp, account, logoURL, fundingSource, principalContacts,
                otherContacts, corpGuarantors, totalFeeDue);
    }

    public class docWrapper {
        @auraEnabled
        public Funding_Source__c fundingSource;
        @auraEnabled
        public Opportunity opportunity;
        @auraEnabled
        public Account account;
        @auraEnabled
        public String logoURL;
        @auraEnabled
        public List<Relationship__c> principalContacts;
        @auraEnabled
        public List<Relationship__c> otherContacts;
        @auraEnabled
        public List<Relationship__c> corpGuarantors;
        @auraEnabled
        public Decimal totalFeeDue;
        public docWrapper(Opportunity opp, Account account, String logoURL, Funding_Source__c fundingSource,
                List<Relationship__c> principalContacts, List<Relationship__c> otherContacts,
                List<Relationship__c> corpGuarantors, Decimal totalFeeDue) {
            this.opportunity = opp;
            this.account = account;
            this.logoURL = logoURL;
            this.fundingSource = fundingSource;
            this.principalContacts = principalContacts;
            this.otherContacts = otherContacts;
            this.corpGuarantors = corpGuarantors;
            this.totalFeeDue = totalFeeDue;
        }
    }

}