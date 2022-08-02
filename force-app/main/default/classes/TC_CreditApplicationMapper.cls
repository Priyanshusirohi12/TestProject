public without sharing class TC_CreditApplicationMapper implements TC_ICreditApplicationMapper {


    public TC_CreditApplication parseApplicationData (Blob jsonBlob) {

        TC_CreditApplication creditApp = (TC_CreditApplication) JSON.deserialize(jsonBlob.toString(), TC_CreditApplication.class);
        TC_CreditApplicationMapperHelper helper = new TC_CreditApplicationMapperHelper (creditApp);

        Account borrower = helper.mapApplicationFieldsToCompany (creditApp.borrower);
        borrower.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Borrower') != null
    		? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Borrower').getRecordTypeId() : null;

        if (borrower.External_Id__c != null) upsert borrower External_Id__c;
    		else insert borrower;

        creditApp.borrower.systemId = borrower.Id;

        if (creditApp.borrower.contactInfo != null) {
          Contact borrowerContInfo = helper.mapApplicationFieldsToContact(creditApp.borrower.contactInfo);
          borrowerContInfo.AccountId = borrower.Id;

          if (borrowerContInfo.External_Id__c != null) upsert borrowerContInfo External_Id__c;
      		else insert borrowerContInfo;

          creditApp.borrower.contactInfo.systemId = borrowerContInfo.Id;
        }


        Opportunity opp = helper.mapApplicationFieldsToOpportunity();
        if (opp.External_Id__c != null) upsert opp External_Id__c;
    		else insert opp;

        creditApp.systemId = opp.Id;


        //this one will need to be updated to allow updates to rels. Logic becomes a bit complicated since we can create duplicates...
        if (creditApp.relationships != null) {
          List <Relationship__c> crels = new List <Relationship__c> ();

          for (TC_CreditApplication.Relationship crel: creditApp.relationships) {
            Relationship__c brel = helper.mapApplicationFieldsToRelationship(crel);
            crels.add(brel);
            //crel.systemId = brel.Id;
          }

          insert crels;
        }


        if (creditApp.equipmentList != null) {

          List <Equipment__c> equipList = new List <Equipment__c> ();

          for (TC_CreditApplication.Equipment eq: creditApp.equipmentList) {
            equipList.add(helper.mapApplicationFieldsToEquipment (eq));
          }

          insert equipList;
        }

        return creditApp;
    }


    public class CreditApplicationMapperException extends Exception {}
}