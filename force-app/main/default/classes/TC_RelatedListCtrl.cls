public with sharing class TC_RelatedListCtrl {



    @AuraEnabled
    public static Boolean getObjectPermission() {


        Id userId = UserInfo.getUserId();
        List<PackageLicense> ps = [SELECT Id FROM PackageLicense where NamespacePrefix = 'tval'];
        PackageLicense p;
        if (ps != null && !ps.isEmpty()) {
            p = ps.get(0);
        } else {
            return false;
        }
        List<UserPackageLicense> license = [SELECT UserId FROM UserPackageLicense WHERE UserId = :userId AND PackageLicenseId = :p.Id];

        if(!license.isEmpty()) {
            return true;
        }else{
            return false;
        }
    }


    @AuraEnabled
    public static List <SObject> getRelatedRecords(String parentId, String sobjectType) {
        System.debug ('getRows trying - ' + parentId);

        try {
            List <SObject> records = retrieveRecords ((Id) parentId, sobjectType);

            return records;
        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }
    }


    @AuraEnabled
    public static String getIconName(String parentId, String sobjectType){

        String u;

        u = getObjectIconName(sobjectType);

        //try parent
        if(u == null){
            Id pId = (Id) parentId;
            String parentSobjectType = pId.getSobjectType().getDescribe().getName();
            u = getObjectIconName(parentSobjectType);
        }


        //set default
        if(u == null) {
            u = 'standard:related_list';
        }


        return u;
    }

    @AuraEnabled
    public static Object getColumnData(String sobjectType, String fieldList){

        fieldList = fieldList.toLowerCase();
        List<String> fList = fieldList.split(',');
        system.debug('LIST fields = ' + fList);
        Set<String> fields = new Set<String>();
        fields.addAll(fList);
        system.debug('SET fields = ' + fields);

        List<Column> cList = new List<Column>();

        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sobjectType).getDescribe().fields.getMap();

        for(Schema.SObjectField f : fieldMap.values()) {
            String fName = f.getDescribe().getName();
            system.debug('looking for fName');
            if(fields.contains(fName.toLowerCase())){

                Column c = new Column();
                if(f.getDescribe().getName() == 'Name'){
                    c.label = f.getDescribe().getLabel();
                    c.fieldName = 'Link__c';
                    c.type = 'url';
                    c.typeAttributes = new TypeAttributes();
                    c.typeAttributes.label = new Label();
                    c.typeAttributes.label.fieldName = 'Name';
                    c.typeAttributes.target = '_self';
                }else {
                    c.label = f.getDescribe().getLabel();
                    c.fieldName = f.getDescribe().getName();
                    c.type = String.valueOf(f.getDescribe().getType()).toLowerCase();
                }
                cList.add(c);
            }
        }

        String jString = JSON.serialize(cList);

        jString = jString.removeEnd(']');
        jString += ',{ "type": "action", "typeAttributes": { "rowActions": [{"label":"Edit", "name":"edit"},{"label":"Delete", "name":"delete"}] }}]';

        return jString;

    }

    @AuraEnabled
    public static void deleteQuoteRecord(String quoteId) {

        try {


        } catch (Exception ex) {
            System.debug ('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
            throw new AuraHandledException('Error : ' + ex.getMessage() + ' - ' + ex.getStacktraceString());
        }

    }


    private class Column{
        private String label;
        private String fieldName;
        private String type;
        //private Boolean editable;
        private TypeAttributes typeAttributes;
    }
    private class TypeAttributes{
        private Label label;
        private String target;
    }
    private class Label{
        private String fieldName;
    }


    @AuraEnabled
    public static void saveRecords(List<sobject> records) {

        system.debug('saving records =' +records);

        update records;


    }


    private static List <Sobject> retrieveRecords (Id parentId, String sobjectType) {

        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sobjectType).getDescribe().fields.getMap();

        List <String> fieldToQuery = new List <String> ();
        String parentLookupField ;

        for(Schema.SObjectField f : fieldMap.values()) {

            //find lookup to parent
            if(f.getDescribe().getType() == Schema.DisplayType.Reference) {
                if(String.valueOf(f.getDescribe().getReferenceTo()[0] ) == parentId.getSobjectType().getDescribe().getName()) {
                    parentLookupField = f.getDescribe().getName();
                }
            }


            fieldToQuery.add(f.getDescribe().getName());
        }

        String query = 'SELECT ';

        query += String.join(fieldToQuery, ',');

        query += ' FROM ' + sobjectType;
        query += ' WHERE '+parentLookupField+' = :parentId';
        query += ' ORDER BY Id';

        system.debug('query == ' + query);

        query = String.escapeSingleQuotes (query);
        List <SObject> sobjList = Database.query(query);

        return sobjList;


        /*


        return new List <Equipment_Detail__c> (
        [SELECT Id
                ,Vin__c
                ,Serial_Number__c
        FROM Equipment_Detail__c
        WHERE Equipment__c = :parentId
        ]);
        */
    }


    private static String getObjectIconName(String sobjectType){

        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }

        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sobjectType == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + sobjectType.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }

        return u;
    }


}