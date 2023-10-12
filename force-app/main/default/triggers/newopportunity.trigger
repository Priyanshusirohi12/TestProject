trigger newopportunity on Opportunity (before insert) {
	Set<Id> setOpp=new Set<Id>();
    List<Opportunity> opportunityList=Trigger.new;
    Map<Id,account> accountMap;
	for(Opportunity opp : opportunityList)
    {
        setOpp.add(opp.AccountId);
    }
     accountMap =new Map<Id, account>([Select Id, account_Type__c from Account where id in : setOpp]);
	for(Opportunity opp : opportunityList)
    {
        if(opp.accountId != null)
        {
            Account acc=accountMap.get(opp.AccountId);
           if(acc.Account_Type__c ==null)
           {
               opp.Stage_Type__c='0';
           }
            else if(acc.Account_Type__c.equals('Reseller') )
            {
                opp.Stage_Type__c ='10';
            }
            else if(acc.Account_Type__c.equals('Buyer'))
            {
                opp.Stage_Type__c ='25';
            }
        }
    }
}