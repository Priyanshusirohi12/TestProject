public with sharing class SearchController {
    @AuraEnabled
    public static List<sObject> search(String objectName, List<String> fields, String searchTerm){
        String searchKeyword = searchTerm + '*';
        String returningQuery = '';
        returningQuery = objectName+' ( Id, '+String.join(fields,',')+')';
        String query = 'FIND :searchKeyword IN Name FIELDS RETURNING '+returningQuery+' LIMIT 100';
        System.debug(' query '+query);
        List<List<sObject>> searchRecords = Search.Query(Query);
        return searchRecords.get(0);
    }
}