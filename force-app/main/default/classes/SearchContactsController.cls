/*	
  	Name			: SearchContactsController
	Date			: 21 May, 2021
	Author			: Priyanshu Sirohi
	Description 	: filtering contact records on the bacis of Name and Email, apply pagination 
					  according to page size and create four buttons .
*/

public with sharing class SearchContactsController {
    public SearchContactsController() {

    }

    @AuraEnabled 
    public static List<Contact> showAllContacts(String inputSearch){
        return [SELECT Id, Name, Email, Account.Name, AccountId, Phone, Type__c 
        FROM Contact 
        WHERE Name LIKE: '%' + inputSearch + '%' OR Email LIKE: '%' + inputSearch + '%' ];
    }
    
}