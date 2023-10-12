public class CreateContactByFutureMethod {
    public CreateContactByFutureMethod(){
        createContact();
        TodaysContact();
    }
    
    @future
    static void createContact(){
       Contact contact = new Contact(LastName ='Future Method');
       insert Contact;
        System.debug('contactId '+contact.Id);
    }
    private void TodaysContact(){
        System.debug('the Todays contact is: '+[Select Id,Name,AccountId from Contact where CreatedDate = Today]);
    }
}