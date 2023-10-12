public class MargeAccountController {
    public List<ContactClassWrapper> contactWrapperList {get;set;}
    ContactClassWrapper ContactClassWrapperObj;  
    public List<SelectOption> accountVfList {get;set;}
    List<Contact> contactList;
    public Id accountId {get;set;}
    public Boolean checkDisable {get;set;}
    public Map<Id,Account> accountMap;
    public Account account {get;set;}
     List<Contact> tempContactList;
    
    public MargeAccountController(){
        checkDisable=true;
        contactList =new List<Contact>();
      	account = new Account();
        contactWrapperList =new List<ContactClassWrapper>();
        for(Contact con : [SELECT Id, Email, Phone, Name FROM Contact where AccountId = : null]){
           ContactClassWrapperObj = new ContactClassWrapper();
            ContactClassWrapperObj.contact=con;
            contactWrapperList.add(ContactClassWrapperObj);
        }
    }
    
    public List<SelectOption> getaccountSelectOption(){
        accountVfList= new List<SelectOption>();
        accountMap = new Map<Id,Account>();
        //contactMap =new Map<id,Contact>();
        for(Account acc : [Select Id, Name, Email__c, city__c, Rating, (SELECT Id, Email, Phone, Name FROM Contacts) from Account])
        {
            accountMap.put(acc.Id,acc);
           accountVfList.add(new SelectOption(acc.Id,acc.Name)); 
            //tempContactList.add(acc.Contacts);
            //contactMap.put(acc.Id,acc.Contacts);
        }
        return accountVfList;
        
    } 
    
    public PageReference selectContactRecord(){
        if(accountId != null){
            for(ContactClassWrapper con : contactWrapperList){
                contactList.clear();
                if(con.isChecked){
                    con.contact.AccountId = accountId;
                    contactList.add(con.contact);  
                    System.debug(contactList);
                }
            }
        }
        if(contactList.size() > 0){
            Upsert contactList;
        }
        PageReference pgContact =new PageReference('/apex/marge_account');
        pgContact.setRedirect(true);
        return pgContact;
    }
    
    public void setEnable(){
        account = new Account();
        checkDisable=false;
        account=accountMap.get(accountId);   
    }
    
    public class ContactClassWrapper{
        public Contact contact {get;set;}
        public Boolean isChecked {get;set;}
        ContactClassWrapper(){
            isChecked=false;
        }   
    }
}