public class PublishingPlatformEvent {
    public PublishingPlatformEvent(){
		List<Order_Shipping__e> orderShippingList = new List<Order_Shipping__e>();
        Order_Shipping__e orderShipping = new Order_Shipping__e(Order_Number__c= '1234', Status__c = 1);
        orderShippingList.add(orderShipping);
        List<Database.SaveResult> result = EventBus.publish(orderShippingList);
        for(Database.SaveResult sr : result){
            if(sr.isSuccess()){
                System.debug('Event is Published Sucessfully ');
            }else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('Error returned: ' +err.getStatusCode());
                }
            }
        }
    }
}