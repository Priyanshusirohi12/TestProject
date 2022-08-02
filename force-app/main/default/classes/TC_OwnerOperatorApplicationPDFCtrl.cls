/**
 * Created by szheng on 2019-07-22.
 */

public without sharing class TC_OwnerOperatorApplicationPDFCtrl {

    public Lead lead {get; set;}
    public String logoURL {get; set;}
    public String disclosureText {get; set;}
    public List<String> documentNames {
        get {
            if(documentNames == null) documentNames = new List<String>();
            return documentNames;}
        set;
    }
    public String submitTime {
        get {
            if(submitTime == null) submitTime = Datetime.now().format('yyyy-MM-dd HH:mm z');
            return submitTime;}
        set;
    }
    public Boolean docExists {get; set;}

    public TC_OwnerOperatorApplicationPDFCtrl() {

        PageReference p = ApexPages.currentPage();

        String leadId = p.getParameters().get('leadId');
        logoURL = p.getParameters().get('logoURL');
        String partnerCode = p.getParameters().get('partnerCode');
        documentNames = (p.getParameters().get('documentNames')).split('/');

        docExists = (documentNames.size() > 1) ? true : false;

        List<Lead> leads = new List<Lead>([SELECT Id, FirstName, LastName, Phone, Email, SSN__c,Date_of_Birth_1__c,

                Contact_Street_1__c,Contact_City_1__c,Contact_State_1__c,Contact_Postal_Code_1__c,

                Equipment_Year__c, Equipment_Make__c,

                Authorized_Credit_Check__c

        FROM Lead WHERE Id=:leadId]);

        if (!leads.isEmpty()) lead = leads[0];

        List <Account> partners = new List <Account> ([SELECT Id, Name, Company_Email__c, Phone, AccountNumber FROM Account WHERE AccountNumber = :partnerCode LIMIT 1]);
        if (partners != null && !partners.isEmpty()) {
            String accountNumber = partners[0].AccountNumber;
            List<TC_Online_Application_Setting__mdt> mdt = new List<TC_Online_Application_Setting__mdt>([SELECT Id, Disclosure_Text__c
            FROM TC_Online_Application_Setting__mdt
            WHERE Label =: accountNumber LIMIT 1]);
            if (mdt != null && !mdt.isEmpty()) {
                disclosureText = mdt[0].Disclosure_Text__c;
            }
        }

    }
}