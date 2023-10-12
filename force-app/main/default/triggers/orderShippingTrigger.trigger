trigger orderShippingTrigger on Order_Shipping__e (after insert) {
    for(Order_Shipping__e event : Trigger.new){
        if(event.Status__c == 1){
            System.debug('Plateform Event is Subscribe');
        }
    }
}