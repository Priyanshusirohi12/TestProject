/**
* @author : sfdc, Tamarack Consulting, Inc.
* @date : 1/15/2017
* @description: VF page for TC_Opportunity_Stage_Status.
*
* © Copyright 2003 - 2017 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/



global class TC_OpportunityVisualStatusExt {
        public TC_OpportunityVisualStatusExt (ApexPages.StandardController sc) {}
        
        
        @RemoteAction
        global static String setStageName(String oppId, String stage) {
            
            try {
                Opportunity opp = new Opportunity (Id = oppId, StageName = stage);
                update opp;
                return 'success';
            } catch (Exception ex) {
                System.debug(ex);
                if (ex.getTypeName() == 'System.DmlException') {
                    throw new TC_OpportunityVisualStatusException ( parseError(ex.getMessage()) );
                } else {
                    throw new TC_OpportunityVisualStatusException (ex.getMessage());
                }
                    
            }
       
        }
        public static String getStageValues(){ 
            String ObjectApi_name = 'Opportunity';
            String Field_name = 'StageName';
            List<String> lstPickvals=new List<String>();
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
            Sobject Object_name = targetType.newSObject();
            Schema.sObjectType sobject_type = Object_name.getSObjectType();
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
            List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues();
       
            for (Schema.PicklistEntry a : pick_list_values) {
                lstPickvals.add('\'' + a.getValue() + '\'');
            }
            
            String strPickvals = String.join(lstPickvals,',');
            System.debug(strPickvals);
            return strPickvals;
        }

        @TestVisible 
        private static String parseError(String errorMsg){
            String regex = '^.+VALIDATION_EXCEPTION, ';
            Pattern p = Pattern.compile(regex);
            Matcher m = p.matcher(errorMsg);
            errorMsg = m.replaceAll('');
            regex = ': \\[.+$';
            p = Pattern.compile(regex);
            m = p.matcher(errorMsg);
            errorMsg = m.replaceAll('');
            return 'Error: ' + errorMsg;
        }
                                                                   
        public class TC_OpportunityVisualStatusException extends Exception {}

}