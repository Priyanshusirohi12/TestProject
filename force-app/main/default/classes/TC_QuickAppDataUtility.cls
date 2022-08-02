public with sharing class TC_QuickAppDataUtility {
	
    public static String createQueryStringFromFieldSet (String sObjectName, String fieldSetName, Set <String> additionalFields) {
        
        String q = ' SELECT ';
        
        Set <String> selectFieldsStringSet = parseFieldSet (sObjectName, fieldSetName);
        selectFieldsStringSet.add('Id');
        if (additionalFields != null) selectFieldsStringSet.addAll(additionalFields);
        
        for (String s : selectFieldsStringSet) {
            q += s + ',';
        }
        
        q = q.removeEnd(',');

        q += ' FROM ' + sObjectName + ' ';
        
        return q;
    }
    
     public static String createQueryStringFromFieldSet (String sObjectName, String fieldSetName) {
        
       return createQueryStringFromFieldSet (sObjectName, fieldSetName, null);
    }
    
    public static Set <String> parseFieldSet (String sObjectName, String fieldSetName ) {
        Schema.SObjectType sot = Schema.getGlobalDescribe().get(sObjectName);
        Map<String, Schema.FieldSet> fsMap = sot.getDescribe().fieldSets.getMap();
		
        Set <String> selectFieldsStringSet = new Set <String> ();
        
        for(Schema.FieldSetMember f : fsMap.get(fieldSetName).getFields()) {
			selectFieldsStringSet.add(f.getFieldPath());
        }
        
        return selectFieldsStringSet;
    }
}