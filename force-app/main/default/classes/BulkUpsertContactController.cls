public class BulkUpsertContactController {
    public List<Contact> contactList{get;set;}
    List<Contact> deleteContactTempList;
    //Public Contact contact;
    public BulkUpsertContactController(){
      // Contact contact = new Contact();
        deleteContactTempList = new List<Contact>();
        contactList = [SELECT Id, LastName, FirstName,AccountId FROM Contact];
    }
    public void addContactButton(){
        contactList.add(new Contact());
    }
    public void deleteContactButton(){
        Contact contact = contactList.remove(contactList.size()-1);
        if(contact.Id != null){
            deleteContactTempList.add(Contact);
        }
       // PageReference pgDelete =new PageReference('/apex/BulkUpsertContact');
        //return pgDelete;
    }
    
    public PageReference saveContactButton(){
        PageReference pgSave;
        try
        {
             Upsert contactList;        	
            if(deleteContactTempList.size() > 0 ){
                delete deleteContactTempList;
            }
            
        }
        catch(System.DMLException e)
        {       
            ApexPages.addmessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Last name is required')); 
        }
        pgSave= new PageReference('/003/o');
        pgSave.setRedirect(true);
        return pgSave;
    }
    public PageReference cancelContactButton(){
        PageReference pageRef = new PageReference('/003/o');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
}