public class CustomerController{
        public Hotal_Customer__c Customer{get;set;}
        public List<Hotal_Customer__c> customerList{get;set;}
        public Id editId{get;set;}
        public String val;
        public boolean editRecord {get;set;}
        public boolean viewRecord {get;set;}
    	public Id editRecordId {get;set;}
    	public Id viewRecordId {get;set;}
    	public Id cloneRecordId {get;set;}
    	//public boolean cloneButton;
        public CustomerController()
        {
             try
    		{
             Customer=new Hotal_Customer__c();
            customerList=new List<Hotal_customer__c>();
            customerList=[SELECT Id, First_Name__c, Last_Name__c, Gender__c, City__c, Email__c, Is_Married__c, Phone__c, Full_Name__c, Address__c FROM Hotal_Customer__c];
            //val=ApexPages.CurrentPage().getparameters().get('Id');
            //editId=ApexPages.CurrentPage().getparameters().get('editId');
                //PageReference pgDelete= new PageReference('/apex/AllCustomer?editId='+editId);
           	editRecord=true;
            if(ApexPages.CurrentPage().getParameters().get('editRecordId')!=null)
            {
                editFunctioning();
          // editRecord=true;
        viewRecord=false;
        editRecordId = ApexPages.currentPage().getParameters().get('editRecordId');
        Customer=[SELECT Id, Last_Name__c, First_Name__c, Is_Married__c, Gender__c, Address__c, City__c, Email__c, Phone__c, Nationality__c, Full_Name__c FROM Hotal_Customer__c where id=:editRecordId];
            }
            if(ApexPages.CurrentPage().getParameters().get('viewRecordId')!=null)
            {
                viewFunctioning();
            }
            if(ApexPages.CurrentPage().getParameters().get('cloneRecordId') !=null)
            {
                cloneFunctioning();
            }
                     }
            catch(dmlException e)
            {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'You have a error in your pages'); 
   			  	 ApexPages.addMessage(myMsg);
            }
    	}
    
    public void editFunctioning(){
        editRecord=true;
        viewRecord=false;
        editRecordId = ApexPages.currentPage().getParameters().get('editRecordId');
        Customer=[SELECT Id, Last_Name__c, First_Name__c, Is_Married__c, Gender__c, Address__c, City__c, Email__c, Phone__c, Nationality__c, Full_Name__c FROM Hotal_Customer__c where id=:editRecordId];
               
    }
    public void cloneFunctioning(){
        viewRecord=false;
        editRecord=true;
        cloneRecordId = ApexPages.currentPage().getParameters().get('cloneRecordId');
        Customer=[SELECT Id, Last_Name__c, First_Name__c, Is_Married__c, Gender__c, Address__c, City__c, Email__c, Phone__c, Nationality__c, Full_Name__c FROM Hotal_Customer__c where id=:cloneRecordId];
       	Customer.id=null;

    }
    public void viewFunctioning(){
        viewRecord=true;
        editRecord=false;
        viewRecordId = ApexPages.currentPage().getParameters().get('viewRecordId');
        Customer=[SELECT Id, Last_Name__c, First_Name__c, Is_Married__c, Gender__c, Address__c, City__c, Email__c, Phone__c, Nationality__c, Full_Name__c FROM Hotal_Customer__c where id=:viewRecordId];
    }
        public PageReference addValues()
        {
        try{
                val=ApexPages.CurrentPage().getparameters().get('Id');
            	//insertAndUpdate();
            	upsert Customer;
            }catch(dmlException e)
            {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Email Must Required'); 
   			   ApexPages.addMessage(myMsg);
            }
            PageReference pgAdd = new PageReference('/apex/AllCustomer');
           	pgAdd.setRedirect(true);
            return pgAdd;
    	}
        /*public void insertAndUpdate()
        {
            try{
                
                upsert Customer;
            }
            catch(dmlException e)
            {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'You have a error in Customer List or your email is same'); 
   			   ApexPages.addMessage(myMsg);
            }
        }*/
        public PageReference deleteValues()
        {
            Customer.id=editId;
            delete Customer;
            PageReference pgDelete= new PageReference('/apex/AllCustomer');
            pgDelete.setRedirect(true);
            return pgDelete;
        }
        public PageReference editValues()
        {
           PageReference pgEdit= new PageReference('/apex/NewCustomer?editRecordId='+editRecordId);
            pgEdit.setRedirect(true);
            return pgEdit;
        }
        public PageReference cloneValues()
        {  
            PageReference pgClone= new PageReference('/apex/NewCustomer?cloneRecordId='+cloneRecordId);
            pgClone.setRedirect(true);
            return pgClone;
        }
        public PageReference viewValues()
        {
            PageReference pgView = new PageReference('/apex/NewCustomer?viewRecordId='+viewRecordId);
            pgView.setRedirect(true);
            return pgView;                                        
        }
    	public pageReference cancelButton()
        {
            PageReference pgCancel =new PageReference('/apex/AllCustomer');
            pgCancel.setRedirect(true);
            return pgCancel;
        }
    	public PageReference saveNewButton()
        {
            upsert Customer;
			PageReference pgSaveNew =new PageReference('/apex/NewCustomer');
            pgSaveNew.setRedirect(true);
            return pgSaveNew;    
        }
    }