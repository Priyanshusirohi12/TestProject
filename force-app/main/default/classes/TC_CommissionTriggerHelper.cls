public class TC_CommissionTriggerHelper {
    
   
        
    public static void calculateNPV (List <Commission__c> commMap) {
             
        //loop over trigger list to get list of Opportunities
        for (Commission__c comm : commMap) {
            if(
                comm.Payment_Amount__c <> NULL 
                && comm.Num_Payments__c <> NULL
                && comm.Discount_Rate__c <> NULL
                && comm.Compound_Frequency__c <> NULL
                && comm.Advance_Arrears_Value__c <> NULL
            ){
                comm.Calculated_NPV__c = TC_NetPresentValue.calculateForPayment(comm.Payment_Amount__c, comm.Num_Payments__c, comm.Discount_Rate__c, comm.Compound_Frequency__c, comm.Advance_Arrears_Value__c );
                comm.Residual_NPV__c = TC_NetPresentValue.calculateForAmount(comm.Residual__c, comm.Num_Payments__c, comm.Discount_Rate__c, comm.Compound_Frequency__c );
            }
        }
    }
    
    public static void checkCommissionConfigMatch (List <Commission__c> commMap) {
        
        List<Id> oppIdList = new List<Id>();
        List<Id> commIdList = new List<Id>();
        
        //loop over trigger list to get list of Opportunities
        for (Commission__c comm : commMap) {
            if(comm.Commission_Config__c == NULL && comm.Opportunity__c <> NULL){
                oppIdList.add(comm.Opportunity__c);
            }
        }
        
        List<Commission_Config__c> configList= [
            SELECT
            Id,
            User_1_Field__c,
            User_1__c,
            User_2_Field__c,
            User_2__c,
            User_3_Field__c,
            User_3__c,
            User_4_Field__c,
            User_4__c,
            Commission_Basis__c,
            Total_Commission__c,
            (SELECT Id, Field_API_Name__c,Operator__c,Value__c FROM Application_Conditions__r )
            FROM Commission_Config__c
            ORDER BY Priority__c
        ];
        
        system.debug('configList = ' + configList);
        
        Map<String, Schema.sObjectField> oppFieldsMap =  Opportunity.sObjectType.getDescribe().fields.getMap();        
        
        String query = 'SELECT ';
        
        String fields = '';
        for(Schema.sObjectField f : oppFieldsMap.values()){
            fields += fields == '' ? '' : ',';
            fields += +String.valueOf(f);
        }
        query += fields;
        
        query += ' FROM Opportunity ';          
        query += ' WHERE Id IN :oppIdList';
        system.debug('Opp query = ' + query);
        system.debug('oppIdList = ' + oppIdList);            
        List<Opportunity> oppList = Database.query(query);
        
        system.debug('oppList = ' + oppList);            
        
        
        
        Map<Id, Config> mapOppConfig = new Map<Id, Config>(); //used to map OppId to Config record that matches condition criteria
        List<Id> userIds = new List<Id>(); //gather userIds to use for a later query
        
        for(Opportunity opp : oppList){
            
            
            for(Commission_Config__c conf : configList){
                Boolean configState = TRUE;
                Boolean conditionState = FALSE;
                for(Application_Condition__c cond : conf.Application_Conditions__r){                       
                    
                    Object sObjVal = opp.get(cond.Field_Api_Name__c);
                    Object condVal = cond.Value__c;
                    
                    
                    System.debug('rule con - ' + sObjVal + ' ' + cond.Operator__c + ' ' + condVal);
                    
                    //field types we can compare with String
                    if (oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.String
                        || oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Reference
                        || oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Email
                        || oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Picklist                           
                        || oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Date
                        || oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.DateTime
                       ) {
                           if (cond.Operator__c == '=') {
                               system.debug('constate eval 1');
                               conditionState = String.valueOf (sObjVal) == String.valueOf (condVal);
                           } else if (cond.Operator__c == '!=') {
                               system.debug('constate eval 2');
                               conditionState = String.valueOf (sObjVal) != String.valueOf (condVal);
                           }
                           
                       } //end if string
                    
                    //field types we can compare with Double
                    else if (oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Currency 
                             || oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Integer
                             || oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Percent
                            ) {
                                if (cond.Operator__c == '=') {
                                    system.debug('constate eval 3');
                                    conditionState = Double.valueOf (sObjVal) == Double.valueOf (condVal);
                                } else if (cond.Operator__c == '!=') {
                                    system.debug('constate eval 4');
                                    conditionState = Double.valueOf (sObjVal) != Double.valueOf (condVal);
                                } else if (cond.Operator__c == '>') {
                                    system.debug('constate eval 5');
                                    conditionState = Double.valueOf (sObjVal) > Double.valueOf (condVal);
                                } else if (cond.Operator__c == '<') {
                                    system.debug('constate eval 6');
                                    conditionState = Double.valueOf (sObjVal) < Double.valueOf (condVal);
                                } else if (cond.Operator__c == '>=') {
                                    system.debug('constate eval 7');
                                    conditionState = Double.valueOf (sObjVal) >= Double.valueOf (condVal);
                                } else if (cond.Operator__c == '<=') {
                                    system.debug('constate eval 8');
                                    conditionState = Double.valueOf (sObjVal) <= Double.valueOf (condVal);
                                }
                                
                                
                            }
                    
                    //handle includes
                    if (oppFieldsMap.get(cond.Field_Api_Name__c).getDescribe().getType() == Schema.DisplayType.Picklist && cond.Operator__c == 'Includes') {
                        
                        Set <String> values = new Set <String> ();
                        
                        for (String s: cond.Value__c.split(';')) {
                            values.add (s);
                        }
                        system.debug('constate eval 9');
                        conditionState = values.contains((String)sObjVal);
                        
                    }
                    System.debug('conditionState for this rule evaluated to ' + conditionState);
                    
                    configState = configState && conditionState;  // states are ANDed together to set config state
                    
                    
                }// end for condition
                
                system.debug('FINAL configState = ' + configState);
                //do we have a confid record where all condition match?
                if(configState == TRUE){
                    
                    Config confObj = new Config();
                    confObj.obj = conf;
                    
                    //add all lookup fields to use in the commission record
                    if(conf.User_1_Field__c <> NULL){
                        system.debug('---------------------------------- opp.get(conf.User_1_Field__c) = ' + opp.get(conf.User_1_Field__c));
                        //if(opp.get(conf.User_1_Field__c) <> NULL){
                        Id userId = String.valueOf(opp.get(conf.User_1_Field__c));
                        confObj.lookupMap.put('User1', userId);
                        userIds.add(userId);
                        //}
                    }
                    if(conf.User_2_Field__c <> NULL){
                        system.debug('---------------------------------- opp.get(conf.User_2_Field__c) = ' + opp.get(conf.User_2_Field__c));
                        //if(opp.get(conf.User_2_Field__c) <> NULL){
                        Id userId = String.valueOf(opp.get(conf.User_2_Field__c));
                        confObj.lookupMap.put('User2', userId);
                        userIds.add(userId);
                        //}
                    }
                    if(conf.User_3_Field__c <> NULL){
                        system.debug('---------------------------------- opp.get(conf.User_3_Field__c) = ' + opp.get(conf.User_3_Field__c));
                        //if(opp.get(conf.User_3_Field__c) <> NULL){
                        Id userId = String.valueOf(opp.get(conf.User_3_Field__c));
                        confObj.lookupMap.put('User3', userId);
                        userIds.add(userId);
                        //}
                    }
                    if(conf.User_4_Field__c <> NULL){
                        system.debug('---------------------------------- opp.get(conf.User_4_Field__c) = ' + opp.get(conf.User_4_Field__c));
                        //if(opp.get(conf.User_4_Field__c) <> NULL){
                        Id userId = String.valueOf(opp.get(conf.User_4_Field__c));
                        confObj.lookupMap.put('User4', userId);
                        userIds.add(userId);
                        //}
                    }                        
                    mapOppConfig.put(opp.Id, confObj);
                    break;
                }                    
                
            }//end config
        }//end opp loop
        
        
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Commission__c FROM User WHERE Id IN :userIds ]);

system.debug('userMap = ' + userMap);
        
        //loop over trigger list again to set configs based on Opportunity parent
        for (Commission__c comm : commMap) {
            if(comm.Commission_Config__c == NULL && comm.Opportunity__c <> NULL){
                if(mapOppConfig.get(comm.Opportunity__c) <> NULL){
                    Config conf = mapOppConfig.get(comm.Opportunity__c);
system.debug('mapOppConfig.get(comm.Opportunity__c) = ' + mapOppConfig.get(comm.Opportunity__c));                    
                    comm.Commission_Config__c = conf.obj.Id;
                    comm.User_1__c = conf.lookupMap.get('User1');
                    
                    comm.Total_Commission__c = 0; //default value for calcs
                    if(conf.obj.Commission_Basis__c == 'Total Commission %'){
                        comm.Total_Commission__c = conf.obj.Total_Commission__c;
                    }else if(conf.obj.Commission_Basis__c == 'User 1 Commission %'){
                        if(userMap.get(comm.User_1__c) <>  NULL){                            
                            if(userMap.get(comm.User_1__c).Commission__c <> NULL){
                        		comm.Total_Commission__c = userMap.get(comm.User_1__c).Commission__c;
                            }
                        }
                    }
                                       
                    comm.User_1_Commission__c = conf.obj.User_1__c == NULL ? NULL : (comm.Total_Commission__c * conf.obj.User_1__c)/100;
                    comm.User_2__c = conf.lookupMap.get('User2');
                    comm.User_2_Commission__c = conf.obj.User_2__c == NULL ? NULL : (comm.Total_Commission__c * conf.obj.User_2__c)/100;
                    comm.User_3__c = conf.lookupMap.get('User3');
                    comm.User_3_Commission__c = conf.obj.User_3__c == NULL ? NULL : (comm.Total_Commission__c * conf.obj.User_3__c)/100;
                    comm.User_4__c = conf.lookupMap.get('User4');
                    comm.User_4_Commission__c = conf.obj.User_4__c == NULL ? NULL : (comm.Total_Commission__c * conf.obj.User_4__c)/100;
                }
            }
        }  
        
    }
    public class Config {
        public Commission_Config__c obj;
        public Map<String,Id> lookupMap = new Map<String,Id> (); 
    }
}