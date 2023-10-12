trigger OpportunityProductTrigger on Opportunity_Product__c (before insert, after insert, after update) {
    if(Trigger.isInsert && Trigger.isBefore){
        for(Opportunity_Product__c product : Trigger.new){
            System.debug('1222 '+product.Opportunity__c);
            if(product.Opportunity__c != null ){
                product.Primary_Product__c =true;
            }
        }   
    }
    if(Trigger.isAfter){
     	Map<Id,Opportunity_Product__c> customMap = new Map<Id,Opportunity_Product__c>();
       	List <Opportunity_Product__c> oppList = [SELECT Id, Name, Primary_Product__c, Opportunity__c, opportunity__r.Id FROM Opportunity_Product__c where id != :Trigger.newMap.keySet()];
        For(Opportunity_Product__c obj : Trigger.newMap.values()){
            customMap.put(obj.Opportunity__c, obj);
        }
        for(Opportunity_Product__c obj : oppList){
            if(customMap.containsKey(obj.Opportunity__c)){
            	obj.Primary_Product__c= false;
            }
        }
        if(Constants.upsertBreak){
           Constants.upsertBreak = false;
            Upsert oppList;
        }
    }
}