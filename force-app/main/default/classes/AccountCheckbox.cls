public class AccountCheckbox {
    public List<Account> accountList{get;set;}
    public List<AccountWrapperClass> fillAccountWrapperList{get;set;}
    public List<AccountWrapperClass> accountWrapperList{get;set;}
    AccountWrapperClass accountWrapperObject;
    public Boolean checkAllAccount{get;set;}
    
	public AccountCheckbox(){
        checkAllAccount = false;
        
        accountList = [SELECT Id, Type, Name, SLA__c, city__c, Account_Type__c, Rating FROM Account];
        accountWrapperList = new List<AccountWrapperClass>();
        fillAccountWrapperList = new List<AccountWrapperClass>();
        for(Account acc : accountList){
            accountWrapperObject = new  AccountWrapperClass();
            accountWrapperObject.account = acc;
            accountWrapperList.add(accountWrapperObject);
        }
        System.debug(accountWrapperList);
    }
    public void fillTable()
    {
        try{
            Contact c = [Select Id, Name, FirstName, LastName From contact Limit 1];
            c.FirstName = 'Priyanshu';
            c.LastName = 'Sirohi';
            update c;
        }catch(System.DMLException e){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e));
            ApexPages.addMessage(myMsg);
        }
        fillAccountWrapperList.clear();
        for(AccountWrapperClass acc :  accountWrapperList)
        {
            	if(acc.accountIsCheck)
                {
                fillAccountWrapperList.add(acc);
                }
        }
    }
     public void setAllCheckBoxSelected(){
       for(AccountWrapperClass acc :  accountWrapperList){
         if(checkAllAccount = true){
             acc.accountIsCheck = true;
         }
       }
    }
    public void setUnselectHearderCheckbox()
    {
        checkAllAccount = true; 
        for(AccountWrapperClass acc :  accountWrapperList){ 
           if(!acc.accountIsCheck){
               checkAllAccount = false;
           }        
    }
    }
   
    public class AccountWrapperClass{
       public  Account account{get;set;}
       public Boolean accountIsCheck{get;set;}
       public AccountWrapperClass(){
            accountIsCheck = false;
        }
    }  
}