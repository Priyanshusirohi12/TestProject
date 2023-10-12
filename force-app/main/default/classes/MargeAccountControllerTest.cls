@isTest
public class MargeAccountControllerTest {
	@testSetup
    public static void fillContactList(){
		Test.startTest();
        	Insert (new Contact(FirstName = 'Akhil', Email = 'akhil@gmail.com', Phone = '535345', LastName = 'verma'));
        Test.stopTest();
        MargeAccountController margeAccountController = new MargeAccountController();
    }
    
    @isTest
    public static void getaccountSelectOptionTest(){
    	MargeAccountController margeAccountController = new MargeAccountController(); 
        margeAccountController.checkDisable = true;
        Test.startTest();
       	Insert (new Account(Name ='Naresh', Email__C ='naresh@gmail.com', City__c = 'Ajmer', Rating='Warm'));
        //[Select Id, Name, Email__c, city__c, Rating, (SELECT Id, Email, Phone, Name FROM Contacts) from Account]
        Test.stopTest();
        margeAccountController.getaccountSelectOption();
        System.assert(margeAccountController.checkDisable);
        margeAccountController.selectContactRecord(); 
    }
    @isTest
    public static void selectContactRecordTest(){
       	Account account = (new Account(Name ='Naresh', Email__C ='naresh@gmail.com', City__c = 'Ajmer', Rating='Warm'));
        Insert account;
        MargeAccountController margeAccountController = new MargeAccountController();
        margeAccountController.contactWrapperList.get(0).isChecked = true;
        margeAccountController.accountId = account.Id;
       	System.assert(account.Id != null);
        margeAccountController.selectContactRecord();
    }
    @isTest
    public static void setEnableTest(){
        Account account = (new Account(Name ='Naresh', Email__C ='naresh@gmail.com', City__c = 'Ajmer', Rating='Warm'));
        Insert account;
        MargeAccountController margeAccountController = new MargeAccountController();
       	Map<Id,Account> accountMap = new Map<Id, Account>([Select Name, Email__c, City__c, Rating FROM Account]);
        margeAccountController.accountMap = accountMap;
        margeAccountController.setEnable();
    }
}