public class TC_ApplicationConditionHelper {
    
    
    public static void validateFields (List <Application_Condition__c> condMap) {
        
        Map<String, Schema.sObjectField> oppFields =  Opportunity.sObjectType.getDescribe().fields.getMap();    
        for (Application_Condition__c cond : condMap) {
            
            if(cond.Field_API_Name__c <> NULL){
                if (oppFields.get(cond.Field_API_Name__c) == null){
                    cond.Field_API_Name__c.AddError('Invalid field name');
                }
            }
            
        }
    }
    
    
}