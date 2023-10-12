public class SelectedAccountDeatail {
	@AuraEnabled (cacheable = true)
    public static List<Contact> getContactList(Id id){
        if(id != null){
       		return[SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId =: id];
        }else 
        {
           return null;
        }
   	}
    
    @AuraEnabled 
    public static Account updateAccountRecord(Account account){
        System.debug('3232 '+ account);
        UPDATE account;
        return account;
    }
}