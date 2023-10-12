@isTest
public class PaginationOnContactTest {
	@testSetup
    public static void paginationOnContactConstroctor(){
        Test.startTest();
        Insert (new Contact(FirstName = 'Umar', LastName = 'Khan', Phone = '43328', Email = 'umar@gmail.com'));
     	Test.stopTest();
        PaginationOnContact paginationOnContact = new PaginationOnContact();
        System.assert(paginationOnContact.allContacts.size() != 0);
    }
    @isTest
    public static void getsizeOptionsTest(){
        PaginationOnContact paginationOnContact = new PaginationOnContact();
        paginationOnContact.getsizeOptions();
    }
    @isTest 
    public static void showSelectSizeDataTest(){
    	PaginationOnContact paginationOnContact = new PaginationOnContact();
        paginationOnContact.selectedNumber = '1';
        paginationOnContact.showSelectSizeData();
        paginationOnContact.selectedNumber = '0';
        paginationOnContact.showSelectSizeData();
    }
    @isTest
    public static void firstPageTest(){
   		PaginationOnContact paginationOnContact = new PaginationOnContact();
        paginationOnContact.contacts = new List<Contact>();
        paginationOnContact.selectedNumber = '1';
        System.debug(paginationOnContact.contacts.size());
        System.debug(paginationOnContact.allContacts);
      
        paginationOnContact.firstPage();
    }
    @isTest
    public static void nextPageTest(){
        PaginationOnContact paginationOnContact = new PaginationOnContact();
        paginationOnContact.allContacts.add(new Contact(FirstName = 'Alfez', LastName ='Khan', Phone ='867676', Email = 'Alfez@gmail.com'));
        paginationOnContact.allContacts.add(new Contact(FirstName = 'tarun', LastName ='mehra', Phone ='867676', Email = 'tarun@gmail.com'));
        paginationOnContact.selectedNumber = '1';
        paginationOnContact.endingNumber = 1;
        paginationOnContact.nextPage();
        
    }
    @isTest
    public static void previousPageTest(){
        PaginationOnContact paginationOnContact = new PaginationOnContact();
        paginationOnContact.allContacts.add(new Contact(FirstName = 'Alfez', LastName ='Khan', Phone ='867676', Email = 'Alfez@gmail.com'));
       	paginationOnContact.selectedNumber = '2';
        paginationOnContact.previousPage();
    }
    @isTest
    public static void lastPsgeTest(){
        PaginationOnContact paginationOnContact = new PaginationOnContact(); 
        paginationOnContact.allContacts.add(new Contact(FirstName = 'Alfez', LastName ='Khan', Phone ='867676', Email = 'Alfez@gmail.com'));
        paginationOnContact.allContacts.add(new Contact(FirstName = 'tarun', LastName ='mehra', Phone ='867676', Email = 'tarun@gmail.com'));
        paginationOnContact.selectedNumber = '1';
        paginationOnContact.lastPage();
    }
    @isTest
    public static void showCurrentSelectPageTest(){
        PaginationOnContact paginationOnContact = new PaginationOnContact(); 
        paginationOnContact.allContacts.add(new Contact(FirstName = 'Alfez', LastName ='Khan', Phone ='867676', Email = 'Alfez@gmail.com'));
        paginationOnContact.selectedNumber = '1';
        paginationOnContact.newPage = 1;
        paginationOnContact.showCurrentSelectPage();
        paginationOnContact.selectedNumber = '0';
        paginationOnContact.showCurrentSelectPage();
    }
}