public class BulkInsertionContactController{
    public List<Contact> contactList{get;set;}
   
    public BulkInsertionContactController(){
     	contactList = new List<Contact>();
        contactList.add(new Contact());
    }
    public PageReference saveContactButton(){
        insert contactList;
        PageReference pgSave = new PageReference('/003/o');
        pgSave.setRedirect(true);
        return pgSave;
    }
    public PageReference cancelContactButton(){
        PageReference pgCancel = new PageReference('/003/o');
        pgCancel.setRedirect(true);
        return pgCancel;
    }
    public void addContactButton(){
        contactList.add(new Contact());
    }
}