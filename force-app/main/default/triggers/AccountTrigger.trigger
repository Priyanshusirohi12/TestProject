trigger AccountTrigger on Account (before insert,before Update) {
    List<Account> accountList =Trigger.new; 
    Map<Id,Account> oldMapValues = Trigger.oldMap;
    if(Trigger.isUpdate)
    {
        for(Account accountObjectUpdate : accountList)
        {
            Account oldAccount =oldMapValues.get(accountObjectUpdate.Id);
            
            if(accountObjectUpdate.Copy_billingc_address__c != oldAccount.Copy_billingc_address__c && accountObjectUpdate.Copy_billingc_address__c)
            {
                accountObjectUpdate.ShippingStreet = accountObjectUpdate.BillingStreet;
                accountObjectUpdate.ShippingCity = accountObjectUpdate.BillingCity;
                accountObjectUpdate.ShippingState = accountObjectUpdate.BillingState;
                accountObjectUpdate.ShippingPostalCode = accountObjectUpdate.BillingPostalCode;
                accountObjectUpdate.ShippingCountry = accountObjectUpdate.BillingCountry;

            }
        }
    }
   
    if(Trigger.isInsert)
    {    
        System.debug('IsInsert');
    for(Account accountObject : accountList)
    {
        System.debug('IsInsert2');
        if(accountObject.Copy_billingc_address__c == true)
        {
            System.debug('IsInsert3');
            accountObject.ShippingStreet = accountObject.BillingStreet;
            accountObject.ShippingCity = accountObject.BillingCity;
            accountObject.ShippingState = accountObject.BillingState;
            accountObject.ShippingPostalCode = accountObject.BillingPostalCode;
            accountObject.ShippingCountry = accountObject.BillingCountry;
        }
    }
    }
}