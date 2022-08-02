public class TC_AccountTriggerHelper {
    
    // Replacing Process Builder "Account - Fill Record Type Text"
    public static void fillRecordTypeText(List<Account> newList) {
        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'Account']);
        for (Account acc : newList) {
            if (acc.RecordTypeId == null) { continue; }
            if (recordTypeMap <> null) {
                String developerName = recordTypeMap.get(acc.RecordTypeId).DeveloperName;
                System.debug('developerName: ' + acc.RecordType.DeveloperName);
                System.debug('developerName from Map: ' + developerName);
                System.debug('record_Type_Text: ' + acc.TC_Record_Type_Text__c);
                if (acc.TC_Record_Type_Text__c != developerName) {
                    acc.TC_Record_Type_Text__c = developerName;
                }    
            }
        }
    }

}