public class DisplayOpportunityFromAccount {
    public List<Account> accountList {get;set;}
    public DisplayOpportunityFromAccount(){
        accountList = [Select Name, (Select Id from Opportunities) from Account];
    }
}