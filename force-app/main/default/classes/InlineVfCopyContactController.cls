public class InlineVfCopyContactController {
    public List<Contact> contactList {get;set;}
    public Boolean isHeaderChecked {get;set;}
    public Boolean isCopiedHeaderChecked {get;set;}
    public Integer contactIndex {get;set;}
    public Integer copiedIndexNumber {get;set;}
    public List<ContactWrapperClass> contactWrapperList {get;set;}
    public Boolean check2 {get;set;}
    public List<ContactWrapperClass> copyContactWrapperList {get;set;}
    public Id accountId;
    public InlineVfCopyContactController(ApexPages.StandardController controller){
        accountId = controller.getId();
        contactList = new List<Contact>();
        contactWrapperList = new List<ContactWrapperClass>();
        copyContactWrapperList = new List<ContactWrapperClass>();
        
        for(Contact contactObj : [SELECT Id, Name FROM Contact WHERE AccountId =: NULL]){
            ContactWrapperClass contactWrapperObj = new ContactWrapperClass();
            contactWrapperObj.contactWrapper = contactObj;
            contactWrapperList.add(contactWrapperObj);
        }
    } 
    
    public void copyContact(){
        //System.debug('$$$$####'+contactIndex);
        ContactWrapperClass WrapperObj = new ContactWrapperClass();
            WrapperObj.contactWrapper = contactWrapperList.get(contactIndex-1).contactWrapper;
        	WrapperObj.isCopyChecked = true;
        	isCopiedHeaderChecked = true;
            copyContactWrapperList.add(WrapperObj);
            contactWrapperList.remove(contactIndex-1);

    }
    
    public void removeCopyContact(){
        System.debug('$$$$####'+copiedIndexNumber);
        ContactWrapperClass classObj = new ContactWrapperClass();
        classObj.contactWrapper = copyContactWrapperList.get(copiedIndexNumber-1).contactWrapper;
        classObj.isChecked = false;
        isCopiedHeaderChecked = false;
        contactWrapperList.add(classObj);
        copyContactWrapperList.remove(copiedIndexNumber-1);
    }
    
    public void isAllSelected(){
        for(ContactWrapperClass wrapperObj : contactWrapperList){
            if(isHeaderChecked){
                ContactWrapperClass classObj = new ContactWrapperClass();
                classObj.isChecked = true;
                classObj.contactWrapper = wrapperObj.contactWrapper;
                copyContactWrapperList.add(classObj);
                classObj.isCopyChecked = true;
                isCopiedHeaderChecked = true;
            }
        }
        contactWrapperList = new List<ContactWrapperClass>();
        isHeaderChecked = false;
    }
    
    public void isAllCoipedSelect(){
        for(ContactWrapperClass wrapperObj : copyContactWrapperList){
            if(isCopiedHeaderChecked == false){
                ContactWrapperClass wrapperClassObj = new ContactWrapperClass();
                wrapperClassObj.contactWrapper = wrapperObj.contactWrapper;
                contactWrapperList.add(wrapperClassObj);
            }
        } 
        copyContactWrapperList = new List<ContactWrapperClass>();
    }
    
    public void addContact(){
        for(ContactWrapperClass wrapperObj : copyContactWrapperList){
            ContactWrapperClass wrapperClassObj = new ContactWrapperClass();
            wrapperClassObj.contactWrapper = wrapperObj.contactWrapper;
            wrapperClassObj.contactWrapper.AccountId = accountId;
            contactList.add(wrapperClassObj.contactWrapper);
        }
        if(contactList.size() > 0){
            update contactList;
        }
    }
    public class ContactWrapperClass{
        public Contact contactWrapper {get;set;}
        public Boolean isChecked {get;set;}
        public Boolean isCopyChecked {get;set;}
    }
}