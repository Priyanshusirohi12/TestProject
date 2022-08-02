public with sharing class TC_RecordLookupCtrl {

    // Method to query records with SOSL
    @AuraEnabled
    public static String search (String objectAPIName, String searchText, List<String> whereClause, List<String> subHeadingFields) {
        
    	objectAPIName = String.escapeSingleQuotes(objectAPIName);
        searchText = String.escapeSingleQuotes(searchText);
        String searchQuery = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + objectAPIName + '(Name ';
        
        if (!subHeadingFields.isEmpty()) {
            searchQuery += ', ' + String.join(subHeadingFields, ',');
        }
        
        if (!whereClause.isEmpty()) {
            searchQuery = searchQuery + ' WHERE ' ;
            searchQuery = searchQuery + String.join(whereClause, ' AND ') ;
        }
        System.debug('<<< serachQuery '+searchQuery);
        searchQuery += ' LIMIT 10)';
        return JSON.serializePretty(search.query(searchQuery));
                                     
    }
    
    // Method to query records with SOQL
    @AuraEnabled
    public static List<SObject> getRecentlyViewed (String objectAPIName, List<String> whereClause, List<String> subHeadingfields) {

        String searchQuery = 'SELECT Id, Name';
        if (!subHeadingfields.isEmpty()) {
            searchQuery += ',' + String.join(subHeadingfields, ',') ;
        }
        searchQuery = searchQuery + ' FROM ' + objectAPIName + ' WHERE '; //LastViewedDate != NULL ';
        if (!whereClause.isEmpty()) {
            //searchQuery = searchQuery + ' AND ' ;
            searchQuery = searchQuery + String.join(whereClause, ' AND ') ;
        }
        if (objectAPIName != 'Group'){
            searchQuery += ' ORDER BY LastViewedDate DESC' ;
        }
        searchQuery += ' LIMIT 10';
        List<SObject> objectList = new List<SObject> ();
        objectList = Database.query(searchQuery);
        return objectList;
    }



}