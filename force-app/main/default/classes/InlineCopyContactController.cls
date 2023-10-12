public class InlineCopyContactController {
    public List<ContactWrapperClass> contactWrapperList {get;set;}
    public List<ContactWrapperClass> copyContactWrapperList {get;set;}
    public Boolean isHeaderChecked {get;set;}
    public Boolean isCopyHeaderChecked {get;set;}
    public Integer indexNumber {get;set;}
    Id accountId;
    
    //Contact Constroter
   
    public InlineCopyContactController(ApexPages.StandardController controller){
       accountId = controller.getId();
        contactWrapperList = new List<ContactWrapperClass>();
        copyContactWrapperList = new List<ContactWrapperClass>();
        for(Contact contact : [SELECT Id, Name,Email, phone, AccountId FROM Contact WHERE AccountId =: NULL ]){
             contactWrapperList.add(new ContactWrapperClass(contact,false));
        }
    }
    
    //To copy contact List 
    
    public void copyContacts(){
        isCopyHeaderChecked = true; 
        copyContactWrapperList.add(new ContactWrapperClass(contactWrapperList.get(indexNumber-1).contactObject,true));
        contactWrapperList.remove(indexNumber-1);
    }
    
    //To remove contact List
    
    public void removeCopyContact(){
        contactWrapperList.add(new ContactWrapperClass(copyContactWrapperList.get(indexNumber-1).contactObject,false));
        copyContactWrapperList.remove(indexNumber-1);
        isHeaderChecked=false;
        if(copyContactWrapperList.size() == 0){
            isCopyHeaderChecked =false;
        }
    }
    
    //To copy all contact List
    
    public void copyAllContacts(){
        if(isHeaderChecked){
            for(ContactWrapperClass contact : contactWrapperList){
             	copyContactWrapperList.add(new ContactWrapperClass(contact.contactObject,true));      
            }
            contactWrapperList.clear();
            isCopyHeaderChecked=true;
        }
    }
    
    //To remove all contact List
    
    public void removeAllCopyContacts(){
        if(!isCopyHeaderChecked){
            for(ContactWrapperClass contact : copyContactWrapperList){
             	ContactWrapperList.add(new ContactWrapperClass(contact.contactObject,false));      
            }
            copyContactWrapperList.clear();
        }  
    }
    
    //To remove all contact List
    
    public void insertCopyList(){
        List<Contact> contantList =new List<Contact>();
        for(ContactWrapperClass updateContact : copyContactWrapperList){
            updateContact.contactObject.AccountId =accountId;
            contantList.add(updateContact.contactObject);
        }
        Upsert contantList;
    }
    
    //Wrapper Class
    
    public class ContactWrapperClass{
        public Contact contactObject {get;set;}
        public Boolean isChecked {get;set;}
        public ContactWrapperClass(Contact contact, Boolean IsChecked){ 
            this.IsChecked =isChecked;
            this.contactObject= contact;
        }
    }        
}