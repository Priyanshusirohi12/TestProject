public class KsCode {
    public Integer pageSize{get;set;}
    public String searchFieldValue{get;set;}
    Integer skipRecords;
    private Integer totalRecords;
    public Boolean isSearchClicked{get;set;}
    private List<Contact> contactList;
    public KsCode(){
        
        skipRecords = 0;
        isSearchClicked = false; 
        contactList =  [SELECT Id, Name, Email, Account.Name, Account.Type, Phone FROM Contact];
        totalRecords = contactList.size();
        pageSize = totalRecords;
        getContactList();
    }
    
    //Displays a list of select option containing page size
    public List<SelectOption> getPageSizeOptions(){
        List<SelectOption> selectOptionList = new List<Selectoption>();
        selectOptionList.add(new SelectOption(String.valueOf(totalRecords),'All'));
        selectOptionList.add(new SelectOption('5','5'));
        selectOptionList.add(new SelectOption('10','10'));
        selectOptionList.add(new SelectOption('15','15'));
        selectOptionList.add(new SelectOption('20','20'));
        return selectOptionList;
    }
    
    //Filtering Contacts based upon Name and Email field
    public void searchContact(){
        //query = 'SELECT Id, Name, Email, Account.Name, Phone FROM Contact';
        if(!String.isEmpty(searchFieldValue.trim())){
            System.debug('search contact');
            //query += ' WHERE Name LIKE\'%'+ searchFieldValue + '%\'' + ' OR Email LIKE \'%' + searchFieldValue + '%\''; 
            
        }
        //List<Contact> tempContactList = Database.query(query);
       	//totalRecords = tempContactList.size();  
        //query += ' LIMIT ' + pageSize + ' OFFSET ' + skipRecords;
        isSearchClicked = true;
    }
    
    public List<Contact> getContactList(){
        
        List<Contact> showAllContactList;
        if(isSearchClicked){
         	 searchContact();  
        }
        else{
            
            if((skipRecords + pageSize) == totalRecords){
            	 showAllContactList  = new List<Contact>();
                System.debug('getcontacts');
                for(Integer i = 0; i < totalRecords; i++){
                	showAllContactList.add(contactList.get(i));
            	}
            }
            else if((skipRecords + pageSize) < totalRecords){
               showAllContactList  = new List<Contact>();
                
               for(Integer i = skipRecords; i < (skipRecords+pageSize); i++){
                 System.debug('ks '+i);  
               showAllContactList.add(contactList.get(i));
            }
                
                  
            }
            
        }
        //System.debug(showAllContactList);
        return showAllContactList;
    }
    
    //Distributing total contacts upon page size and displaying
    public void changePageSize(){
        firstPage();
        //getContactList(s);
    }
    
    //Displays first page of contact Records
    public void firstPage(){
        skipRecords = 1;
        getContactList();
    }
    
    //Displays the next page of contact records depending upon selected pageSize
    public void nextPage(){
       skipRecords += pageSize;
       getContactList();
    }
    
    //Displays the last page of contact records depending upon selected pageSize
    public void lastPage(){
        if(Math.mod(totalRecords , pageSize)!=0){
            skipRecords = pageSize * ((totalRecords/pageSize));
        }
        else
        	skipRecords = pageSize * ((totalRecords/pageSize)-1);
    }   
    
    //Displays the previous page of contact records depending upon selected pageSize
    public void previousPage(){
        skipRecords -= pageSize;
    }
    
    public Boolean getNext(){
        if((skipRecords + pageSize) >= totalRecords)  
            return true;  
        else  
            return false;  
    }
    
    public Boolean getPrevious(){
        if(skipRecords > 0)
            return false;
        else
            return true;    
    }
}