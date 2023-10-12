public class AccountInsertAction {
  @InvocableMethod(label='Insert Accounts' description='Inserts the accounts specified and returns the IDs of the new accounts.' category= 'Account')
  public static void insertAccounts(List<Account> tempAccount) {
   // Database.SaveResult[] results = Database.insert(accounts);
    Results response = new Results();

   
    response.tempDateTime = tempAccount[0].Appointment_Date_Time__c;
    System.debug('response.tempDateTime '+response.tempDateTime);
  }
   public class Results {
    @InvocableVariable(label='Records for Output' description='yourDescription' required=true)
    public DateTime tempDateTime;
  }
}