public with sharing class TC_InvoiceCtrlLtng {

    @auraEnabled
    public static invoiceWrapper grabInvoiceWrapper(ID recordId) {

        // Query to get relevant details from Opportunity
        List<Opportunity> opportunities = new List<Opportunity>([SELECT ID,(SELECT ID,Name,Approved_Rate__c,
                Funding_Source__r.Name,
                Funding_Source__r.BillingStreet,
                Funding_Source__r.BillingCity,
                Funding_Source__r.BillingState,
                Funding_Source__r.BillingPostalCode,
                Doc_Fee__c,Commission__c
        FROM Funding_Sources__r
        WHERE Selected__c = True)
                ,Invoice_Comments__c,Name,Invoice_Number__c,Lease__c 
        FROM Opportunity
        WHERE ID=:recordId]);


        // Query to get relevant client LK EF Lender Account
        Id userId = UserInfo.getUserId();
        List<User> users = new List<User>([SELECT Id, Account.Id
        FROM User WHERE Id = :userId]);
        String thisTenantAccountId = null;
        if(!users.isEmpty()) {
            thisTenantAccountId = users.get(0).Account.Id;
        }
        String singleTenantAccountId = Origination_Setting__c.getInstance() != null ? Origination_Setting__c.getInstance().Own_Company_Account_Id__c : null;

        String usersAccountId = thisTenantAccountId != null ? thisTenantAccountId : singleTenantAccountId;
        List<Account> accounts = new List<Account>([SELECT Id, Name, BillingStreet, BillingCity, BillingState,
                BillingPostalCode, Bank_Name__c, Account_Number__c, Routing_Number__c,
                Logo_Url__c, AccountNumber
        FROM Account
        WHERE Id = :usersAccountId]);

        Account client = !accounts.isEmpty() ? accounts[0] : null;
        String accountNumber = !accounts.isEmpty() ? (accounts[0].AccountNumber != null ? accounts[0].AccountNumber : accounts[0].Id) : null;
        String logoURL = TC_RetrieveAccountLogo.retrieve(accountNumber, null);

        // Determine what routing number to display on invoice
        List<PermissionSetAssignment> perm = new List<PermissionSetAssignment>([SELECT Id
        FROM PermissionSetAssignment
        WHERE Assignee.Id =: UserInfo.getUserId()
        AND PermissionSet.Name IN ('Invoice_Routing_Numbers', 'Invoice_Routing_Numbers2')]);
        Integer invoiceNumber;
        Funding_Source__c fundingSource;
        Decimal totalDue;
        String routingNumber;
        Opportunity opp;

        if(!opportunities.isEmpty()) {
            opp = opportunities[0];

            // Update generated invoice number
            try {
                opp.Invoice_Number__c = opp.Invoice_Number__c + 1;
            } catch (Exception e) {
                System.debug(e.getMessage());
                // Exception thrown for null value/invoice has never been generated before
                opp.Invoice_Number__c = 1;
            }
            invoiceNumber = (opp.Invoice_Number__c).intValue();

            // Retrieve details about selected funding source
            try {
                fundingSource = opp.Funding_Sources__r[0];
                totalDue = opp.Funding_Sources__r[0].Commission__c + opp.Funding_Sources__r[0].Doc_Fee__c;
            } catch (NullPointerException e) {
                /*CustomExceptionData data = new CustomExceptionData('NoFeeError', 'No documentation and/or commission fee on selected funding source.');
                throw new AuraHandledException(JSON.serialize(data));*/
                totalDue = null;
            } catch (ListException e) {
                /*CustomExceptionData data = new CustomExceptionData('NoFundingSourceError', 'No funding source selected.');
                throw new AuraHandledException(JSON.serialize(data));*/
                totalDue = null;
            }

            // Confirm that user has permission set to display routing number
            if(perm.isEmpty()) {
                routingNumber = '<<Must have Invoice Routing Numbers permission set to display>>';
            } else {
                routingNumber = client.Routing_Number__c;
            }
        }

        return new invoiceWrapper(invoiceNumber, fundingSource, totalDue, routingNumber, opp, client, logoURL);
    }

    @auraEnabled
    public static void updateOpportunity(Id recordId, Integer invoiceNum) {
        try {
            List<Opportunity> opportunities = new List<Opportunity>([SELECT ID,Invoice_Number__c FROM Opportunity WHERE ID=:recordId]);
            if(!opportunities.isEmpty()) {
                Opportunity opp = opportunities[0];
                opp.Invoice_Number__c = invoiceNum;
                update opp;
            }
        } catch (Exception e) {
            // Exception thrown for null value/invoice has never been generated before
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class invoiceWrapper {
        @auraEnabled
        public String invoiceDate;
        @auraEnabled
        public Integer invoiceNumber;
        @auraEnabled
        public Funding_Source__c fundingSource;
        @auraEnabled
        public Decimal totalDue;
        @auraEnabled
        public String routingNumber;
        @auraEnabled
        public Opportunity opportunity;
        @auraEnabled
        public Account client;
        @auraEnabled
        public String logoURL;
        public invoiceWrapper(Integer invoiceNumber, Funding_Source__c fundingSource, Decimal totalDue,
                String routingNumber, Opportunity opp, Account client, String logoURL) {
            this.invoiceDate = Date.Today().Format();
            this.invoiceNumber = invoiceNumber;
            this.fundingSource = fundingSource;
            this.totalDue = totalDue;
            this.routingNumber = routingNumber;
            this.opportunity = opp;
            this.client = client;
            this.logoURL = logoURL;
        }
    }

}