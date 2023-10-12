public class fatchContactBasedOnAccount {
	@AuraEnabled
    public static List<Contact> getContactBaseOnAccount(Id accountId, String rating){
        System.debug('1 '+accountId);
        System.debug('2 ' +rating);
       List<Contact> contactList = [SELECT Id, Name, Phone, Email, Title
                                       FROM Contact 
                                       WHERE AccountId =: accountId AND Account.Rating =: rating];       
       System.debug(contactList); 
       return contactList;
    }
}