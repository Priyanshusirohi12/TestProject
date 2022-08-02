public class TC_CommissionConfigTriggerHelper {

    public static void validateUserLookups (List <Commission_Config__c> configMap) {
        

system.debug('configMap = ' +configMap);        
        Map<String, Schema.sObjectField> oppFields =  Opportunity.sObjectType.getDescribe().fields.getMap();    
        for (Commission_Config__c conf : configMap) {
            
            
            if(conf.User_1_Field__c <> NULL){
                if (oppFields.get(conf.User_1_Field__c) == null){
                    conf.User_1_Field__c.AddError('Invalid field name');
                }
                if(!isValidUserLookup(oppFields.get(conf.User_1_Field__c))){
                    conf.User_1_Field__c.AddError('Field must be a Lookup to a User record');
                }
            }
            if(conf.User_2_Field__c <> NULL){
                if (oppFields.get(conf.User_2_Field__c) == null){
                    conf.User_2_Field__c.AddError('Invalid field name');
                }
                if(!isValidUserLookup(oppFields.get(conf.User_1_Field__c))){
                    conf.User_2_Field__c.AddError('Field must be a Lookup to a User record');
                }
            }
            if(conf.User_3_Field__c <> NULL){
                if (oppFields.get(conf.User_3_Field__c) == null){
                    conf.User_3_Field__c.AddError('Invalid field name');
                } 
                if(!isValidUserLookup(oppFields.get(conf.User_1_Field__c))){
                    conf.User_3_Field__c.AddError('Field must be a Lookup to a User record');
                }
            }
            if(conf.User_4_Field__c <> NULL){ 
                if (oppFields.get(conf.User_4_Field__c) == null){
                    conf.User_4_Field__c.AddError('Invalid field name');
                }  
                if(!isValidUserLookup(oppFields.get(conf.User_1_Field__c))){
                    conf.User_4_Field__c.AddError('Field must be a Lookup to a User record');
                }
            }
        }
    }
    
    private static Boolean isValidUserLookup(sObjectField f){
        system.debug('f.getDescribe().getReferenceTo() = ' + f.getDescribe().getReferenceTo()[0] );
        if(f.getDescribe().getType() <> Schema.DisplayType.Reference){
            return FALSE;
        }else{
            if(String.valueOf(f.getDescribe().getReferenceTo()[0] ) <> 'User'){
                return FALSE;
            }
        }
        return TRUE;
    }
    
    
        
    public static void setCommissionValues (List <Commission_Config__c> configMap) {
        for (Commission_Config__c conf : configMap) {
            
            if(conf.Commission_Basis__c == 'User 1 Commission %'){
                
            }
            
        }
    }
    
}