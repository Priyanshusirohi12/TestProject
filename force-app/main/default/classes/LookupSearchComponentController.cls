public class LookupSearchComponentController {
    
    @AuraEnabled
    public static List<SObJect> getResults(String value) {
        List<SObJect> sObjectResultList = new List<SObJect>();
        String query =  'FIND \''+ String.escapeSingleQuotes(value.trim())+ '\' RETURNING User(Id, Name Order by Name Limit 10)'; 	
            System.debug('Query==='+query);
            List<List<SObject>> results = search.query(query);
            System.debug('results::'+results );
        	Integer i = 0;
            for(list<User> objectList :results ){
                sObjectResultList.addAll(objectList);
                
            }
            System.debug('listOfValues:: '+sObjectResultList );
        return sObjectResultList;
    }
}