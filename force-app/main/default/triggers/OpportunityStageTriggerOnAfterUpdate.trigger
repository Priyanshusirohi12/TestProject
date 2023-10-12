trigger OpportunityStageTriggerOnAfterUpdate on Account (After insert,After update ) {
    Map<Id,Account> accountMap= Trigger.newMap;
    Set<Id> accountId= accountMap.keySet();
    List<Opportunity> OpportunityList =new List<Opportunity>();
    //List<Opportunity> OpportunityList2 =new List<Opportunity>();
    
   /* for(Account acc : AccountMap)
    {
        accountId.add(acc.id);
    }*/
    System.debug(accountId.size());
    if(accountId.size() >0){
       // System.debug(accountId.size());
        OpportunityList = [Select Id,AccountId, Stage_Type__c from Opportunity where AccountId in :accountId ];
        System.debug(OpportunityList);
    }
    for(Opportunity opp :OpportunityList){
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
        //opportunityList.add(opp);
            
        }
            if(opportunityList.size()>0){
            upsert OpportunityList;
            }
}