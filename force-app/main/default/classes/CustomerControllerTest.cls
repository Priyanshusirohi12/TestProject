@isTest
public class CustomerControllerTest {
	
    @testSetup static void fillCustomer(){
        Hotal_Customer__c customer = new Hotal_Customer__c(First_Name__c ='test1', Gender__c= 'Male');
        Test.startTest();
        insert customer;
        Test.stopTest();
        CustomerController customerController= new CustomerController();
        List<Hotal_Customer__c> customerList = customerController.customerList;
        System.assertEquals('test1',customerList.get(0).First_Name__c);
    }
    @isTest
    public static void getCustomer(){
        
       //Hotal_Customer__c customer = [Select Id, Gender__c,First_Name__c from Hotal_Customer__c];
        Hotal_Customer__c customer = new Hotal_Customer__c(First_Name__c ='test1', Gender__c= 'Male');
        Test.startTest();
        insert customer;
        Test.stopTest();
		CustomerController customerController= new CustomerController();
        List<Hotal_Customer__c> customerList = customerController.customerList;
        System.assertEquals('test1',customerList.get(0).First_Name__c);	        
    }
    
    public static testMethod void customerInsert(){
        CustomerController customerController= new CustomerController();
       	customerController.Customer.First_Name__c = 'Test 2';
        customerController.Customer.Gender__c = 'Male';
        customerController.addValues();
        System.assert(customerController.customer.id != null);
    }
    public static testMethod void customerInsertWithOutAnyRecord(){
        CustomerController customerController= new CustomerController();
        customerController.addValues();
        System.assert(customerController.customer.id != null);
    }
    @isTest
    public static void cancel(){
        CustomerController customerController= new CustomerController();
        customerController.cancelButton();
    }
    public static testMethod void deleteCustomer(){
        CustomerController customerController = new CustomerController();
        Hotal_Customer__c customer = [Select Id,First_Name__c from Hotal_Customer__c];
        customerController.editId=customer.Id;
        System.assert(customer.Id != null);
        System.debug(customerController.editId);
        customerController.deleteValues();
        
    }
    public static testMethod void editPage(){
        CustomerController customerController= new CustomerController();
        CustomerController.editValues();
        CustomerController.cloneValues();
        CustomerController.viewValues();
        //CustomerController customerController= new CustomerController();
        customerController.customer.First_Name__c = 'Test32' ;
        customerController.customer.email__c='122@gmail.com';
        customerController.customer.Gender__c='Male';
        customerController.saveNewButton();
        //CustomerController.cancelButton();
        //CustomerController
    }
    public static testMethod void customerUpdateForEdit(){
        Hotal_Customer__c Customer = new Hotal_Customer__c(First_Name__c='Test 12', Email__c='test12@gmail.com', Gender__c= 'Male');
       	Test.startTest();
        insert Customer;
        Test.stopTest();
        System.assert(Customer.id != null);
        
        ApexPages.CurrentPage().getparameters().put('editRecordId',customer.Id);
        CustomerController customerController= new CustomerController();
        //customerController.editValues();
        System.assert(customerController.editRecordId != null);
        customerController.Customer.Gender__c ='Female';
        customerController.addValues();
        //customerController.insertAndUpdate();
        //System.assertEquals('Female',Customer.Gender__c );
    }
   
     public static testMethod void customerUpdateForClone(){
        Hotal_Customer__c Customer = new Hotal_Customer__c(First_Name__c='Test 1', Email__c='test@gmail.com', Gender__c= 'Female');
       	Test.startTest();
        insert Customer;
        Test.stopTest();
        System.assert(Customer.id != null);
        ApexPages.CurrentPage().getparameters().put('cloneRecordId',customer.Id);
        CustomerController customerController= new CustomerController();
        System.assert(customerController.cloneRecordId != null);
        customerController.Customer.Gender__c ='Female';
        customerController.Customer.Id =null;
        customerController.addValues();
        System.assertEquals('Female',customerController.Customer.Gender__c);
    }
    public static testMethod void customerView(){
        Hotal_Customer__c Customer = new Hotal_Customer__c(First_Name__c = 'Test33', Gender__c='Male');
        Test.startTest();
        insert Customer;
        Test.stopTest();
        System.assert(Customer.Id != null);
        
        ApexPages.CurrentPage().getParameters().put('viewRecordId', Customer.Id);
        CustomerController customerController= new CustomerController();
        System.assert(customerController.customerList.size() == null,customerController.customerList);
        System.assert(customerController.viewRecordId != null);
    }
   
    
    
    
    /*public static void getCustomers(){
        Hotal_Customer__c customer = new Hotal_Customer__c();
        CustomerController customerController= new CustomerController();
        List<Hotal_Customer__c> customerList = customerController.customerList;
        System.assert(customerList.size() != 0, 'Size '+customerList.size()); 
    }
    public static testMethod void getCustomerWithData(){
        Hotal_Customer__c customer = new Hotal_Customer__c(First_Name__c='Test 12', Email__c='test12@gmail.com', Gender__c= 'Male');
       	Test.startTest();
        insert customer;
        Test.stopTest();
        
        System.assert(customer.Id != null);
        CustomerController customerController= new CustomerController();
        List<Hotal_Customer__c> customerList = customerController.customerList;
        System.assertEquals('Test 12',customerList.get(0).First_Name__c);
        System.assertEquals('test12@gmail.com',customerList.get(0).Email__c);
        System.assertEquals('Male',customerList.get(0).Gender__c);
    }
    public static testMethod void customerInsert(){
        CustomerController customerController= new CustomerController();
       	customerController.Customer.First_Name__c = 'Test 2';
        customerController.Customer.Email__c = '1@gmail.com';
        customerController.Customer.Gender__c = 'Male';
        //customerController.insertAndUpdate();
        customerController.addValues();
        System.assert(customerController.customer.id != null);
    }
    
    public static testMethod void customerUpdateForEdit(){
        Hotal_Customer__c Customer = new Hotal_Customer__c(First_Name__c='Test 12', Email__c='test12@gmail.com', Gender__c= 'Male');
       	Test.startTest();
        insert Customer;
        Test.stopTest();
        //System.assert(customer.id != null);
        ApexPages.CurrentPage().getparameters().put('editRecordId',customer.Id);
        CustomerController customerController= new CustomerController();
        //customerController.editValues();
        System.assert(customerController.editRecordId != null);
        customerController.Customer.Gender__c ='Female';
        
        customerController.addValues();
        //customerController.insertAndUpdate();
        //System.assertEquals('Female',Customer.Gender__c );
    }
    public static testMethod void customerUpdateForClone(){
        Hotal_Customer__c Customer = new Hotal_Customer__c(First_Name__c='Test 1', Email__c='test@gmail.com', Gender__c= 'Female');
       	Test.startTest();
        insert Customer;
        Test.stopTest();
        //System.assert(Customer.id != null);
        ApexPages.CurrentPage().getparameters().put('cloneRecordId',customer.Id);
        CustomerController customerController= new CustomerController();
        System.assert(customerController.cloneRecordId != null);
        //customerController.Customer.Gender__c ='Female';
        customerController.Customer.Id =null;
        //customerController.cloneValues();
        //customerController.insertAndUpdate();
        customerController.addValues();
        System.assertEquals('Female',customerController.Customer.Gender__c);
    }
    public static testMethod void customerView(){
        Hotal_Customer__c Customer = new Hotal_Customer__c(First_Name__c = 'Test33', Gender__c='Male');
        Test.startTest();
        insert Customer;
        Test.stopTest();
        System.assert(Customer.Id != null);
        ApexPages.CurrentPage().getParameters().put('viewRecordId', Customer.Id);
        CustomerController customerController= new CustomerController();
        //customerController.viewValues();
        System.assert(customerController.viewRecordId != null);
        
        
       	 
    }*/
}