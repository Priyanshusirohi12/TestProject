public class InsertEmailRecords {
	@AuraEnabled
    public static void insertRecords(Creator_Email__c emailRecord){
      
		  insert emailRecord;
      System.debug('emailRecord '+emailRecord);
    }
}