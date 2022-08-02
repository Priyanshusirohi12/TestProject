public without sharing class TC_DeleteRecordCtrl {
    // Dec 11 2019 added ability for this to delete any record the user has visibility to
    public static String sobjectType;
    
	@AuraEnabled
    public static void deleteRecordById (Id recordId) {
        if (recordId != null) {
            sobjectType = recordId.getSObjectType () + '';
            SObject record = (SObject) Type.forName (sobjectType).newInstance ();
            record.Id = recordId;
            try {
                delete record;
            } catch (Exception e) {
                System.debug ('Error deleting record ' + e);
                throw new AuraHandledException(e.getMessage());
            }
        }
    } 
    @AuraEnabled
	public static Id getListViewId() {
        List <User> users = new List <User> ([SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()]);
        User u;
        if (!users.isEmpty ()) {
            u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()][0];
        }

        if (u != null && u.ContactId != null) {
            List <Contact> con = new List <Contact> ([SELECT Id, Account.On_Delete_Account_List_View_Name__c, Account.On_Delete_Contact_List_View_Name__c, Account.On_Delete_Opportuntiy_List_View_Name__c, Account.On_Delete_Lead_List_View_Name__c  FROM Contact WHERE Id = :u.ContactId]);
        	String listViewName = sobjectType == 'Contact' ? con[0].Account.On_Delete_Contact_List_View_Name__c : sobjectType == 'Account' ? con[0].Account.On_Delete_Account_List_View_Name__c : sobjectType == 'Opportunity' ? con[0].Account.On_Delete_Opportuntiy_List_View_Name__c : con[0].Account.On_Delete_Lead_List_View_Name__c;
            
            if (listViewName == null || listViewName == '') listViewName = sobjectType == 'Contact' ? 'All Contacts' : sobjectType == 'Account' ? 'All Accounts' : sobjectType == 'Opportunity' ? 'All Deals' : 'All Open Leads';

            List<ListView> listViews = new List <ListView> ([SELECT Id FROM ListView WHERE SobjectType = :sobjectType AND Name = :listViewName]);
            
            return listViews.isEmpty () ? null : listViews[0].Id;           
        }
        return null;


	}
}