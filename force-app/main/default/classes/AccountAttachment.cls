public class AccountAttachment {
    public List <Account> accountList {get;set;}
    // AccountAttachment method
 	public AccountAttachment()
    {
        accountList=[Select Name, Phone,Email__c, (Select Id, Name, ContentType from Attachments) from Account];
    }
}