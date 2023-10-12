trigger OpportunityTrigger on Opportunity (before insert) {
    Set<Id> accountId= new Set<Id>();
    List<Opportunity> OpportunityList =Trigger.new;
    Map<Id, Account> accountMap;
    //List<Opportunity> OpportunityList2 =new List<Opportunity>();
    
   /* for(Account acc : AccountMap)
    {
        accountId.add(acc.id);
    }*/
    for(Opportunity opp : OpportunityList){
        accountId.add(opp.AccountId);
    }
   accountMap =new Map<Id,Account>([Select id, Account_Type__c from Account where id in : accountId]);
    for(Opportunity opp : OpportunityList){
        if(opp.AccountId != null){
            Account acc= accountMap.get(opp.AccountId);
            if(acc.Account_Type__c ==null){
               opp.Stage_Type__c='0';
           }
            else if(acc.Account_Type__c.equals('Reseller') ){
                opp.Stage_Type__c ='10';
            }
            else if(acc.Account_Type__c.equals('Buyer')){
                opp.Stage_Type__c ='25';
            }
            else if(acc.Account_Type__c.equals('Current')){
                opp.Stage_Type__c ='100';
            }
             
        }           
    }
}