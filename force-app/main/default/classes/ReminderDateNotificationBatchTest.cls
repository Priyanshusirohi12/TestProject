@isTest
public class ReminderDateNotificationBatchTest {
    @TestSetup
    public static void createRecords(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'test', Email='test1464@amazon.com', 
        EmailEncodingKey='UTF-8', LastName='record', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='test1464@amazon.com');
        System.runAs(u) {
        	// The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        
        Account account = (new Account(Name ='Naresh', Email__c ='naresh@gmail.com', City__c = 'Ajmer', Rating='Warm'));
        Insert account;
        
        List<Stimulus_Deal__c> stimulusDealList = new List<Stimulus_Deal__c>();
        stimulusDealList.add(new Stimulus_Deal__c(Name ='Test', Investment_ID__c ='test', Account__c = account.Id, OwnerId = u.Id , Reminder_Date__c = System.today() - 10));
        stimulusDealList.add(new Stimulus_Deal__c(Name ='Test 2', Investment_ID__c ='test', Account__c = account.Id, OwnerId = u.Id , Reminder_Date__c = System.today() - 10));
        Test.startTest();
        	Insert stimulusDealList;
        Test.stopTest();
        
        Assert.areEqual(2, stimulusDealList.size());
        
    }
    
   	@isTest
    private static void ReminderDateNotificationBatchTestPassMethod(){
        Date dateValue = System.today() - 10;
        List<Stimulus_Deal__c> stimulusDealList = [SELECT Id, Name,OwnerId, Owner.Email,Investment_ID__c, Owner.Name, Account__r.Name, Reminder_Date__c
                                                   FROM Stimulus_Deal__c
                                                   WHERE Reminder_Date__c =: dateValue];
      	Test.startTest();
    		//DataBase.executeBatch(new ReminderDateNotificationBatch());
    		ReminderDateNotificationBatchScheduler sh1 = new ReminderDateNotificationBatchScheduler();
			String sch = '58 59 11 1/1 * ? *';
        	system.schedule('ScheduleDaily', sch, sh1); 
 
        Test.stopTest();
        Assert.areEqual( 2, stimulusDealList.size());
    }
}