public with sharing class TC_DataUtil {
   
    public static List <SObject> queryObjectFields (String objectType, String whereClause) {

        
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectType);

        Map <String, Schema.SObjectField> fldObjMap = sObjType.getDescribe().fields.getMap();
        List <Schema.SObjectField> fldObjMapValues = fldObjMap.values();

        String queryString = 'SELECT ';
        
        
        for(Schema.SObjectField s : fldObjMapValues) {
           String fieldName = s.getDescribe().getName();

           
          
               // Continue building your dynamic query string
               queryString += fieldName + ',';

        }

        //     Trim last comma
        queryString = queryString.removeEnd(',');

        // Finalize query string
        queryString += ' FROM ' +objectType;
        queryString += ' WHERE ' + whereClause;
        System.debug(LoggingLevel.INFO, queryString);
        try {

            List <SObject> objList = Database.query(queryString);
            return objList;
        } catch (Exception e) {
            System.debug(e);
            return new List <SObject> ();
        }
    }


    public static String createSelectAllQueryString (String sObjectApiName, String whereClause, Set <String> parentFieldsSet) {

        if (parentFieldsSet == null) parentFieldsSet = new Set <String> ();

        Map <String, Schema.SObjectType> allSObjects = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectSchema = allSObjects.get(sObjectApiName);
        Schema.DescribeSObjectResult d = sObjectSchema.getDescribe();
        Map<String, Schema.SObjectField> fldObjMap = d.fields.getMap();

        String queryString = 'SELECT ';
        
        
        for (Schema.SObjectField s : fldObjMap.values()) {
                queryString += s.getDescribe().getName() + ',';
            
        }

        if (!parentFieldsSet.isEmpty()) {
            for (String s: parentFieldsSet) {
                queryString += s + ',';
            }
        }

        // Trim last comma
        queryString = queryString.removeEnd(',');

        // Finalize query string
        queryString += ' FROM ' + sObjectApiName;
        queryString += ' WHERE ';

        if (!String.isEmpty(whereClause)) {
            queryString += whereClause;
        } else {
            queryString += 'Id != null LIMIT 1000';
        }
        System.debug('querystring >>>>>' + queryString);
        return queryString;
    }

}