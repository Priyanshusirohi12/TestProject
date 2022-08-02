/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 1/27/2017
* @description: Class to handle lead conversion for Tamarack data
*
* © Copyright 2003 - 2017 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/

public without sharing class TC_LeadConversion {
   
    public static void processContacts (Map <Id, Lead> leadNewMap, Map <Id, Lead> leadOldMap) {
        
        
        Contact contact;// = new Contact();
        Account account;// = new Account();
        List<Contact> contactList = new List<Contact>();
        List<Account> accountList = new List<Account>();
        ID convertedAccountId = NULL;
        ID convertedOpportunityId = NULL;
        ID convertedContactId = NULL;
        
        //map the account order to the relationship type needed
        List<String> accountRelType = new List<String>();
        
        
        // no bulk processing; will only run from the UI for dedupe matching on Account and Contact
        if (leadNewMap.size() == 1) {              
            for (Lead lead: leadNewMap.values()) {          
                //only on lead conversion
                if (lead.isConverted == true && leadOldMap.get(lead.Id).isConverted == false) {                    
                    
                    convertedAccountId = lead.ConvertedAccountId;
                    convertedOpportunityId = lead.ConvertedOpportunityId;
                    convertedContactId = lead.ConvertedContactId;

                    // Set Broker Record Type -- Gitlab LK #192
                    List<User> userList = new List<User>([SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId()]);

                    if (userList[0].Profile.Name == 'LK EF Broker') {
                        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
                        Id brokerEquipmentFinId = recordTypes.get('Broker Equipment Finance').getRecordTypeId();
                        Opportunity updatedOpp = new Opportunity(Id = convertedOpportunityId, RecordTypeId = brokerEquipmentFinId);
                        upsert updatedOpp;
                    }

                    // Set Primary Contact and Additional Guarantor Information
                    Contact primaryContact = new Contact(Id = convertedContactId, Birthdate = lead.Date_of_Birth_1__c);
                    if(lead.Contact_Street_1__c != NULL) primaryContact.MailingStreet = lead.Contact_Street_1__c;
                    if(lead.Contact_City_1__c != NULL) primaryContact.MailingCity = lead.Contact_City_1__c;
                    if(lead.Contact_Country_1__c != NULL) primaryContact.MailingCountryCode = lead.Contact_Country_1__c;
                    if(lead.Contact_State_1__c != NULL) primaryContact.MailingStateCode = lead.Contact_State_1__c;
                    if(lead.Contact_Postal_Code_1__c != NULL) primaryContact.MailingPostalCode = lead.Contact_Postal_Code_1__c;
                    if(lead.Guarantor_Annual_Income_1__c != NULL) primaryContact.Guarantor_Annual_Income__c = lead.Guarantor_Annual_Income_1__c;
                    if(lead.SSN__c != NULL) primaryContact.SSN__c = lead.SSN__c;
                    primaryContact.Is_Guarantor__c = lead.Personal_Guarantor__c;
                    upsert primaryContact;
                                       
                    if(!String.isBlank(lead.Last_Name_2__c) ){
                        
                        contact = new Contact();
                        contact.LastName = lead.Last_Name_2__c;
                        contact.AccountId = lead.ConvertedAccountId;
                        contact.Is_Guarantor__c = lead.Personal_Guarantor_2__c;
                        if(lead.First_Name_2__c != NULL) contact.FirstName = lead.First_Name_2__c;
                        if(lead.Title_2__c != NULL) contact.Title = lead.Title_2__c;  
                        if(lead.Email_2__c != NULL) contact.Email = lead.Email_2__c;
                        if(lead.SSN_2__c != NULL) contact.SSN__c = lead.SSN_2__c;
                        if(lead.Mobile_2__c != NULL) contact.MobilePhone = lead.Mobile_2__c;
                        if(lead.Contact_Home_Phone_Number_2__c != NULL) contact.HomePhone = lead.Contact_Home_Phone_Number_2__c;
                        if(lead.Contact_Street_2__c != NULL) contact.MailingStreet = lead.Contact_Street_2__c;
                        if(lead.Contact_City_2__c != NULL) contact.MailingCity = lead.Contact_City_2__c;
                        if(lead.Contact_Country_2__c != NULL) contact.MailingCountryCode = lead.Contact_Country_2__c;
                        if(lead.Contact_State_2__c != NULL) contact.MailingStateCode = lead.Contact_State_2__c;
                        if(lead.Contact_Postal_Code_2__c != NULL) contact.MailingPostalCode = lead.Contact_Postal_Code_2__c; 
                        if(lead.Guarantor_Annual_Income_2__c != NULL) contact.Guarantor_Annual_Income__c = lead.Guarantor_Annual_Income_2__c; 
                        if(lead.Date_of_Birth_2__c != NULL) contact.BirthDate = lead.Date_of_Birth_2__c; 
                        //if(lead.Ownership_Percent_2__c != NULL) contact.Ownership_Percent__c = lead.Ownership_Percent_2__c;                                
                        
                        contactList.add(contact);
                                               
                    }

                    if(!String.isBlank(lead.Last_Name_3__c) ){
                        
                        contact = new Contact();
                        contact.LastName = lead.Last_Name_3__c;
                        contact.AccountId = lead.ConvertedAccountId;
                        contact.Is_Guarantor__c = lead.Personal_Guarantor_3__c;
                        if(lead.First_Name_3__c != NULL) contact.FirstName = lead.First_Name_3__c;
                        if(lead.Title_3__c != NULL) contact.Title = lead.Title_3__c;  
                        if(lead.Email_3__c != NULL) contact.Email = lead.Email_3__c;
                        if(lead.SSN_3__c != NULL) contact.SSN__c = lead.SSN_3__c;
                        if(lead.Mobile_3__c != NULL) contact.MobilePhone = lead.Mobile_3__c;
                        if(lead.Contact_Home_Phone_Number_3__c != NULL) contact.HomePhone = lead.Contact_Home_Phone_Number_3__c;
                        if(lead.Contact_Street_3__c != NULL) contact.MailingStreet = lead.Contact_Street_3__c;
                        if(lead.Contact_City_3__c != NULL) contact.MailingCity = lead.Contact_City_3__c;
                        if(lead.Contact_Country_3__c != NULL) contact.MailingCountryCode = lead.Contact_Country_3__c;
                        if(lead.Contact_State_3__c != NULL) contact.MailingStateCode = lead.Contact_State_3__c;
                        if(lead.Contact_Postal_Code_3__c != NULL) contact.MailingPostalCode = lead.Contact_Postal_Code_3__c; 
                        if(lead.Guarantor_Annual_Income_3__c != NULL) contact.Guarantor_Annual_Income__c = lead.Guarantor_Annual_Income_3__c; 
                        if(lead.Date_of_Birth_3__c != NULL) contact.BirthDate = lead.Date_of_Birth_3__c; 
                        //if(lead.Ownership_Percent_3__c != NULL) contact.Ownership_Percent__c = lead.Ownership_Percent_3__c;                                
                        
                        contactList.add(contact);
                                                
                    }

                    if(!String.isBlank(lead.Last_Name_4__c) ){
                        
                        contact = new Contact();
                        contact.LastName = lead.Last_Name_4__c;
                        contact.AccountId = lead.ConvertedAccountId;
                        contact.Is_Guarantor__c = lead.Personal_Guarantor_4__c;
                        if(lead.First_Name_4__c != NULL) contact.FirstName = lead.First_Name_4__c;
                        if(lead.Title_4__c != NULL) contact.Title = lead.Title_4__c;  
                        if(lead.Email_4__c != NULL) contact.Email = lead.Email_4__c;
                        if(lead.SSN_4__c != NULL) contact.SSN__c = lead.SSN_4__c;
                        if(lead.Mobile_4__c != NULL) contact.MobilePhone = lead.Mobile_4__c;
                        if(lead.Contact_Home_Phone_Number_4__c != NULL) contact.HomePhone = lead.Contact_Home_Phone_Number_4__c;
                        if(lead.Contact_Street_4__c != NULL) contact.MailingStreet = lead.Contact_Street_4__c;
                        if(lead.Contact_City_4__c != NULL) contact.MailingCity = lead.Contact_City_4__c;
                        if(lead.Contact_Country_4__c != NULL) contact.MailingCountryCode = lead.Contact_Country_4__c;
                        if(lead.Contact_State_4__c != NULL) contact.MailingStateCode = lead.Contact_State_4__c;
                        if(lead.Contact_Postal_Code_4__c != NULL) contact.MailingPostalCode = lead.Contact_Postal_Code_4__c; 
                        if(lead.Guarantor_Annual_Income_4__c != NULL) contact.Guarantor_Annual_Income__c = lead.Guarantor_Annual_Income_4__c; 
                        if(lead.Date_of_Birth_4__c != NULL) contact.BirthDate = lead.Date_of_Birth_4__c; 
                        //if(lead.Ownership_Percent_4__c != NULL) contact.Ownership_Percent__c = lead.Ownership_Percent_4__c;                                
                        
                        contactList.add(contact);
                                                
                    }
                    
                }  
            }

            //get relationship record types
            Map<String, String> relRecTypes = new Map<String, String>();  
            relRecTypes.put('Individual', Schema.SObjectType.Relationship__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId());
            relRecTypes.put('Corporation',Schema.SObjectType.Relationship__c.getRecordTypeInfosByName().get('Corporation').getRecordTypeId());


            List<Relationship__c> rel_maps = new List<Relationship__c>();
            List<OpportunityContactRole> role_maps = new List<OpportunityContactRole>();
            List<Contact> contactUpdates = new List<Contact>();
            List<Id> contactSuccess = new List<Id>();           
            
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = FALSE;
            
            
            //attempt to insert new contacts
            List<Database.SaveResult> saveResults = Database.insert(contactList, dml);
            for(Integer i=0;i<saveResults.size();i++){
                Database.SaveResult saveResult = saveResults.get(i);
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        Contact c = contactList.get(i);  //get the contact that caused the dupe error
                        Contact dupe = new Contact();

                        //If there are duplicates, an error occurs
                        if (error instanceof Database.DuplicateError) {
                            Database.DuplicateError duplicateError = (Database.DuplicateError)error;
                            Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();

                            //find duplicate records
                            Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();

                            //Grab first match result which contains the duplicate record found
                            Datacloud.MatchResult matchResult = matchResults[0];
                                    
                            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                            Datacloud.MatchRecord matchRecord = matchrecords[0];
                            
                            
                            //Contact matchContact = matchRecord.getRecord();
                            System.debug('MatchRecord: ' + matchRecord.getRecord());
                            System.debug('ContactId: ' + matchRecord.getRecord().Id);
                            
                            //set Id to overwrite existing
                            dupe.Id =  matchRecord.getRecord().Id;
                            
                            //overwrite with new profile info
                            if(c.Email != NULL) dupe.Email = c.Email;
                            if(c.Title != NULL) dupe.Title = c.Title;
                            if(c.LastName != NULL) dupe.LastName = c.LastName;
                            if(c.FirstName != NULL) dupe.FirstName = c.FirstName;
                            if(c.SSN__c != NULL) dupe.SSN__c = c.SSN__c;
                            if(c.MobilePhone != NULL) dupe.MobilePhone = c.MobilePhone;
                            if(c.HomePhone != NULL) dupe.HomePhone = c.HomePhone;
                            if(c.MailingStreet != NULL) dupe.MailingStreet = c.MailingStreet;
                            if(c.MailingCity != NULL) dupe.MailingCity = c.MailingCity;
                            if(c.MailingStateCode != NULL) dupe.MailingStatecode = c.MailingStatecode;
                            if(c.MailingPostalCode != NULL) dupe.MailingPostalCode = c.MailingPostalCode;
                            if(c.Guarantor_Annual_Income__c != NULL) dupe.Guarantor_Annual_Income__c = c.Guarantor_Annual_Income__c;
                            if(c.BirthDate != NULL) dupe.BirthDate = c.BirthDate;                          
                            
                            contactUpdates.add(dupe);  //add for update

                            //create new opportunity relationship mapping
                            if(convertedOpportunityId != NULL && contactList.get(i).Is_Guarantor__c == TRUE){
                                 Relationship__c rel_map = new Relationship__c(
                                    Relationship_Type__c = 'Personal Guarantor',
                                    Person__c = matchRecord.getRecord().Id,
                                    Related_Opportunity__c = convertedOpportunityId,
                                    RecordTypeId = relRecTypes.get('Individual')
                                );                       
                                rel_maps.add(rel_map);
system.debug('+++++ ADDING RELATIONSHIP - ' + c); 
                            }else{
system.debug('----- NOT ADDING RELATIONSHIP - ' + c);                                
                            }
                          
                        }
                    }
                }else{   
                    
                    
                    //collect Ids of successes
                    System.debug('SUCCESS INSERT for - ' + saveResults.get(i).getId());             
                    contactSuccess.add(saveResults.get(i).getId());                    
                    
                    
                    //create new opportunity relationship mapping
                    if(convertedOpportunityId != NULL && contactList.get(i).Is_Guarantor__c == TRUE){
                        Relationship__c rel_map = new Relationship__c(
                            Relationship_Type__c = 'Personal Guarantor',
                            Person__c = contactList.get(i).Id,
                            Related_Opportunity__c = convertedOpportunityId,
                            RecordTypeId = relRecTypes.get('Individual')
                        );                       
                        rel_maps.add(rel_map);
                    } 

                }
                
            } //end contact saveResults loop


            system.debug('looking for dupes from ' + contactSuccess);
            //check successes for duplicates
            List<DuplicateRecordItem> dupeItems = [
                SELECT Id, RecordId, DuplicateRecordSetId 
                FROM DuplicateRecordItem
                WHERE RecordId IN :contactSuccess
            ]; 
            
            system.debug('*******Dupe Items = ' + dupeItems);


          
            System.debug('ContactId: ' + contactUpdates);
            //update dupe contacts
            update(contactUpdates);
                     
            
            //insert mappings
            System.debug('rel_maps: ' + rel_maps);
            insert(rel_maps);               
           
            System.debug('role_maps: ' + role_maps);
            insert(role_maps);
            
//throw new localException('done here');  



            
        }
        
        
    }

    public class localException extends Exception { }
}