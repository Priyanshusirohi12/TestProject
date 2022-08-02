@isTest
public class TC_LeadConversionTest {

    @isTest
    static void leadConversionTest() {

        Lead lead = new Lead ();
        lead.Company = 'Test123';
        lead.FirstName = 'Test';
        lead.LastName = 'Lead';
        lead.Personal_Guarantor_2__c = TRUE;
        lead.First_Name_2__c = 'Test';
        lead.Last_Name_2__c = 'Test2';
        lead.SSN_2__c = '123-12-1234';
        lead.Email_2__c = 'test@email.com';
        lead.Last_Name_3__c = 'Test3';
        lead.Personal_Guarantor_3__c = TRUE;
        lead.Last_Name_4__c = 'Test4';
        lead.Personal_Guarantor_4__c = TRUE;
        lead.Authorized_Credit_Check__c = TRUE;
        lead.Date_of_Birth_1__c = Date.TODAY();

        insert lead;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);

        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        Lead dupe = new Lead ();
        dupe.Company = 'Test123';
        dupe.FirstName = 'Test';
        dupe.LastName = 'Lead';
        dupe.SSN_2__c = '123-12-1234';
        dupe.Email_2__c = 'test@email.com';
        dupe.First_Name_2__c = 'Test';
        dupe.Last_Name_2__c = 'Test2';
        dupe.Last_Name_4__c = 'Test4';
        insert dupe;

        lc.setLeadId(dupe.id);

        convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());



        Lead dupe2 = new Lead ();
        dupe2.Company = 'Test123';
        dupe2.FirstName = 'Test';
        dupe2.LastName = 'Lead';
        dupe2.Personal_Guarantor_2__c = TRUE;
        dupe2.First_Name_2__c = 'Test';
        dupe2.Last_Name_2__c = 'Test2';
        dupe2.Email_2__c = 'test@email.com';
        dupe2.SSN_2__c = '123-12-1234';
        dupe2.Last_Name_4__c = 'Test4';

        insert dupe2;

        lc.setLeadId(dupe2.id);

        convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

    }
}