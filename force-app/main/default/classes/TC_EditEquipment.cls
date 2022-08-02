/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 10/5/2017
* @description: Page controller for editing equipment grid for an opportunity
*
* © Copyright 2003 - 2017 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/
public class TC_EditEquipment {
    
    String[] fields = new String[]{
            'Id',
            'Name',
            'Cost_Per_Unit__c',
            'Serial_Numbers__c',
            'Quantity__c',
            'Make__c',
            'Model__c',
            'Condition__c',
            'Year__c',
            'Residual__c',
            'Vendor_Name__c'
    };

    public String getheader(){
        String[] header = new String[]{
                'Id', 
                'Name',
                'Cost Per Unit',
                'Serial Numbers',
                'Quantity',
                'Make',
                'Model',
                'Condition',
                'Year',
                'Residual',
                'Vendor'
                };
        return JSON.serialize(header);
    }
                
    Map<Id, Equipment__c> eqMap = new Map<Id, Equipment__c>();
                
    String eqData;
    Boolean andClose;
    
    public string callfunc{get;set;}
    String errRow;
    
    public void seterrRow(String n) {
        errRow = n;
    }
            
    public String geterrRow() {
        return errRow;
    }
    
        
    public void setandClose(Boolean n) {
        andClose = n;
    }
    public Boolean getandClose() {
        return andClose;
    } 
    
    public String id = ApexPages.currentPage().getParameters().get('id');
    
     public String getid(){
        return opp.Id;
    }

    public Opportunity opp = [SELECT Id, AccountId, Name FROM Opportunity WHERE Id =:id ];
      
    public String getoppName(){
        return opp.Name;
    }

    public String cid = ApexPages.currentPage().getParameters().get('cid') == '' ? NULL : ApexPages.currentPage().getParameters().get('cid');
    

    public String returnUrl = cid == NULL ? '/'+id : '/'+cid;
   
    public String getReturnUrl(){
        return returnUrl;
    }    
        
    public void seteqData(String n) {
        eqData = n;
    }
    
    public String geteqData() {
        return eqData;
    }    
    
    public String getequipment(){
               
        String query = '';
        
        for(String f : fields){
            query += (query == '' ? '' : ',')+f;
        }
        
        
        query = 'SELECT ' + query;        
        query += ' FROM Equipment__c ';
        query += ' WHERE Opportunity__c =:id';
        
        if(cid <> NULL){
            query += ' AND Certificate_of_Acceptance__c =: cid';
        }
        
        System.debug('query = ' + query);        
        List<Equipment__c> eqList = Database.query(query);
        System.debug('eqList = ' + eqList);   
        List<List<String>> records = new List<List<String>>();
        
        //clear eqMap for new query
        eqMap.clear();
        
        for(Equipment__c eq : eqList){
            
            
            //add record to map to handle deletes later
            eqMap.put(eq.Id, eq);
            
            String[] row = new String[]{};
                for(String f : fields){
                    Map<String, Schema.SObjectField> fMap = Schema.SObjectType.Equipment__c.fields.getMap();
                    Schema.SObjectField field = fMap.get(f);
                    
                    if(field == NULL){
                        row.add(String.ValueOf(eq.get(f)));
                    }else{
                        Schema.DisplayType fType = field.getDescribe().getType();
                        //if(f <> 'Id'){
                        if(eq.get(f) == NULL){
                            row.add(''); 
//                        }else if(String.valueOf(fType) == 'Datetime'){
//                            Datetime fval = Datetime.valueof(eq.get(f));
//                            row.add(fval.month()+'/'+fval.day()+'/'+fval.year());                    
                        }else if(String.valueOf(fType) == 'Date'){
                            Date fval = Date.valueof(eq.get(f));
                            row.add(fval.month()+'/'+fval.day()+'/'+fval.year());                    
                        }else{
                            row.add(String.ValueOf(eq.get(f)));                    
                            
                        }
                    }
                }
            
            
            records.add(row);
            
            
        }
        
        
      
        String output =  JSON.serialize(records);
system.debug('output = ' + output);        
        
        return output;
        
    }
    
    
    public PageReference save(){

        System.debug('saving');
        System.debug('eqData is = ' + eqData);
        
        List<Object> eqString = (List<Object>) JSON.deserializeUntyped(eqdata);
        List<Equipment__c> eqUpsertList = new List<Equipment__c>();
        Integer row;
        Integer col;
        System.debug('eqString is = ' + eqString);
        Integer i;
        
        Map<String, Id> vendorMap = generateVendorMap(eqString);

        
        try{
            row=0;
            for( Object eq : eqString){
                List<Object> eqItem = (List<Object>) eq;
                Equipment__c e = new Equipment__c();
                
                //required for new Equipment
                e.Opportunity__c = id;
                
                i=0; //don't skip Id
                for( Object item : eqItem){
                    String fName = fields[i];
                    
                    Map<String, Schema.SObjectField> fMap = Schema.SObjectType.Equipment__c.fields.getMap();
                    Schema.SObjectField field = fMap.get(fName);
                    Schema.DisplayType fType = field.getDescribe().getType();
                    
system.debug('---------' + fName + ' ('+fType+') = '+item);
                    String val = String.valueOf(item);
                    
                    
                    //special cases
                    if(fName == 'Vendor_Name__c'){
                        
                        if(val <> '' && val <> NULL){
                            if(vendorMap.containsKey(val)){
                                e.put('Vendor__c', vendorMap.get(val));
                            }else{
                                throw new eqException('Vendor ' + val + ' not found.  Please create Vendor first.');
                            }
                        }
                       
                    }else if(item == NULL || item == ''){
                        e.put(fName, NULL); 
                                          
                    }else if(String.valueOf(fType) == 'Date'){
                        Date d = Date.parse(val);
                        e.put(fName, d);
                    }else if(String.valueOf(fType) == 'Currency' || String.valueOf(fType) == 'Double' || String.valueOf(fType) == 'Percent'){
                        e.put(fName, Decimal.valueOf(val));
                    }else{
                        e.put(fName, val);
                    }
                    
                    
                    
                    i++;
                }
                
                if(e.Name <> NULL){
                    eqUpsertList.add(e); 
                }
                
                //remove from map so we don't delete
                if(eqMap.get(e.Id) <> NULL){
                    eqMap.remove(e.Id);
                }
                
                system.debug('eqUpsertList = ' +eqUpsertList);
                row++;
            }
            
           // upsert eqUpsertList;
                 
            List<Database.UpsertResult> saveResults = Database.upsert(eqUpsertList,Equipment__c.Id.getDescribe().getSObjectField(),false);
system.debug('saveResults = ' + saveResults);
system.debug('saveResults.size() = ' + saveResults.size());
            for(Integer j=0;j<saveResults.size();j++){
system.debug('looking for ' + j);
                Database.UpsertResult saveResult = saveResults.get(j);
system.debug('--->saveResult = ' + saveResult);                
                if (!saveResult.isSuccess()) {
system.debug('found error ');                    
                    row = j;

                    for(Database.Error err : saveResult.getErrors()){
                        //col = err.getField()
                        throw new eqException(err.getMessage());
                    }

                }
            }
       
            //delete eqMap (remaing Ids that were not upserted from orignal query = deleted from grid)
system.debug('records left to Delete='+eqMap);
            delete eqMap.values();
            
        } catch (Exception ex) {
            
            errRow = String.valueOf(row);
            callfunc='<script> errRow("'+String.valueOf(row)+'"); </script>';
            
            System.debug('>>>>>>');
            ApexPages.addMessages(ex);
            System.debug(ex);
            return null;
        }
        
        callfunc='<script> clearErr(); </script>';                    
        ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.INFO, 'Records successfully saved!');         
        ApexPages.addMessage(err); 

        getequipment();
        
system.debug('saved with anClose = ' + andClose);
        if(andClose == TRUE){
            PageReference pageRef = new PageReference(returnUrl);
            return pageRef;
        }else{
            return null;
        }
    }
    
    public class eqException extends Exception {}

    private Map<String, Id> generateVendorMap(List<Object> eqString){

        Map<String, Id> vendorMap = new Map<String, Id>();
        Set<String> vendorNames = new Set<String>();
        
        Integer i;
        for( Object eq : eqString){
            List<Object> eqItem = (List<Object>) eq;   
                        
            i=0; //don't skip Id
            for( Object item : eqItem){
                String fName = fields[i];
                if(fName == 'Vendor_Name__c' && String.valueOf(item) <> '' && String.valueOf(item) <> NULL){
                    vendorNames.add(String.valueOf(item));
                }
                i++;
            }
        }
        if(vendorNames.size() > 0 ){
            String inNames = '';
            for(String n : vendorNames) {
                inNames += (inNames=='' ? '' : ',' )+ '\'' + n + '\'';
            } 
            
            String query = 'SELECT Name, Id FROM Account WHERE Name IN( ' + inNames + ' )';
            
            List<Account> vendors = Database.query(query);
            
            for(Account vendor : vendors){
                vendorMap.put(vendor.Name, vendor.Id);
            }           
        }

        return vendorMap;
        
    }

 
}