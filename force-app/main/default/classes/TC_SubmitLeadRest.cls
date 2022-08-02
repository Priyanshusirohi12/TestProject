@RestResource (urlMapping='/lead/*')
global without sharing class TC_SubmitLeadRest {
    @HttpPost
    global static void submitLead () {
        // Deserializing
        TC_LeadSubmissionResponseBean responseBean = new TC_LeadSubmissionResponseBean ();
        Map<String, Object> requestMap = new Map<String, Object> ();
        
        if (!Test.isRunningTest ()) {
            try {
                requestMap = (Map<String, Object>) JSON.deserializeUntyped (RestContext.request.requestBody.toString ());
            } catch (Exception e) {
                responseBean.status = 'error';
                responseBean.messages.add ('Error deserializing the JSON request: ' + e);
            }
        } else {
            String authCode = [SELECT API_Authorization_Code__c FROM Account LIMIT 1].API_Authorization_Code__c;
            requestMap = (Map<String, Object>) JSON.deserializeUntyped ('{"requestAPIAuthorizationCode" : "' + authCode + '","Company":"Company","LastName":"LastName"}');
        }
        
        // Authenticating
        if (responseBean.status != 'error') {
            responseBean.status = 'error';
            
            // return right away if requestAPIAuthorizationCode doesn't match
            Id brokerOrVendorId;
            Boolean isBroker = false;
            
            if (requestMap.get ('requestAPIAuthorizationCode') != null) {
                String authorizationCode = (String) requestMap.get ('requestAPIAuthorizationCode');
                List <Account> brokersOrVendors = new List <Account> ([SELECT Id, RecordType.DeveloperName FROM Account WHERE API_Authorization_Code__c = :authorizationCode AND RecordType.DeveloperName IN ('Vendor','Broker')]);
                brokerOrVendorId = !brokersOrVendors.isEmpty () ? brokersOrVendors[0].Id : null;
                if (!brokersOrVendors.isEmpty () && brokersOrVendors[0].RecordType.DeveloperName == 'Broker') isBroker = true;
            }
            
            if (brokerOrVendorId == null) {
                responseBean.messages.add ('Incorrect Authentication Code');
            } else {
                responseBean.status = 'success';
            }
            
            // validating
            if (responseBean.status != 'error') {
                Set <String> missingRequiredFields = new Set <String> ();
                
                try {
                    // Mapping
                    Lead l = new Lead ();
                    Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    System.debug('brokerOrVendorId ' + brokerOrVendorId);
                    
                    List <Lead_API_Default_Value__mdt> defaultValues = [SELECT Field__r.QualifiedAPIName, Value__c
                                                                        FROM Lead_API_Default_Value__mdt
                                                                        WHERE (Account_Id__c = null OR Account_Id__c = :brokerOrVendorId)
                                                                        AND Object__r.QualifiedAPIName = 'Lead'
                                                                       ];
                    
                    mapJSONToObject (defaultValues, schemaMap, l, requestMap, brokerOrVendorId, missingRequiredFields); 
                    
                    if (isBroker)
                        l.put ('Broker__c', brokerOrVendorId);
                        
                    if (missingRequiredFields.size () > 0) {
                        String error = 'Please provide the following required fields: ';
                        for (String field : missingRequiredFields)
                            error += field + ', ';
                        
                        throw new TC_SubmitLeadRestException (error.substring (0, error.length () - 2) + '.');
                    }
                    
                    // DML
                    insert l;
                    responseBean.status = 'success';
                    responseBean.leadId = l.Id;
                    responseBean.messages.add ('Lead record was created at ' + Datetime.now ());
                } catch (TC_SubmitLeadRestException e) {
                    responseBean.status = 'error';
                    responseBean.messages.add (e.getMessage ());
                } catch (Exception e) {
                    responseBean.status = 'error';
                    responseBean.messages.add ('Error inserting the record - ' + e.getMessage ());
                }
            }
        }
        
        if (!Test.isRunningTest ()) RestContext.response.responseBody = Blob.valueOf (JSON.serialize (responseBean));
    }
    
    private static void mapJSONToObject (List <Lead_API_Default_Value__mdt> defaultValues, Map <String, Schema.SObjectType> schemaMap, sObject record, Map <String, Object> recordMap, String brokerOrVendorId, Set <String> missingRequiredFields) {
        String currentField;
            
        try {
            for (Lead_API_Default_Value__mdt defaultValue : defaultValues) {
                record.put (defaultValue.Field__r.QualifiedAPIName, defaultValue.Value__c);
            }
                        
            Schema.DescribeSObjectResult dsr = schemaMap.get(String.valueOf (record.getSObjectType ())).getDescribe ();
            Map <String, Schema.SObjectField> objFieldMap = dsr.fields.getMap ();
            
            for (String field : recordMap.keySet()) {
                currentField = field;
                
                if (objFieldMap.get (field) != null) {
                    if (objFieldMap.get (field).getDescribe().getType () == Schema.DisplayType.Date)
                        record.put (field, Date.valueOf((String) recordMap.get (field)));
                    else
                        record.put (field, recordMap.get (field));
                }
            }
            
            String recordTypeName;
            
            if (objFieldMap.get ('RecordTypeId') != null) {
                recordTypeName = (String) record.get ('RecordTypeId');
                
                for (Schema.RecordTypeInfo rti : dsr.getRecordTypeInfos ()) {
                    System.debug ('rti.isDefaultRecordTypeMapping () ' + rti.isDefaultRecordTypeMapping ());
                    System.debug ('rti.getName () ' + rti.getName ());
                    
                    if ((recordTypeName == null && rti.isDefaultRecordTypeMapping ()) 
                        || recordTypeName == rti.getName ()) {
                            recordTypeName = rti.getName ();
                            record.put ('RecordTypeId', rti.getRecordTypeId ());
                        }
                }
            }
                        
            List <Lead_API_Required_Field__mdt> requiredFields = [SELECT Field__r.QualifiedAPIName, Label
                                                                  FROM Lead_API_Required_Field__mdt
                                                                  WHERE Record_Type__c = :recordTypeName
                                                                  AND (Account_Id__c = null OR Account_Id__c = :brokerOrVendorId)
                                                                  AND Object__r.QualifiedAPIName = :'' + record.getSObjectType ()
                                                                 ];
            
            for (Lead_API_Required_Field__mdt requiredField : requiredFields) {
                if (record.get (requiredField.Field__c == null ? requiredField.Label : requiredField.Field__r.QualifiedAPIName) == null)
                    missingRequiredFields.add (record.getSObjectType () + '.' + (requiredField.Field__c == null ? requiredField.Label : requiredField.Field__r.QualifiedAPIName));
            }
        } catch (Exception e) {
            throw new TC_SubmitLeadRestException ('Error processing field ' + record.getSObjectType () + '.' + currentField + ' - ' + e.getMessage ());
        }
    }
    
    public class TC_SubmitLeadRestException extends Exception {}
}