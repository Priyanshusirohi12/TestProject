/*	
  	Name			: SearchContactController
	Date			: 19 May, 2021
	Author			: Priyanshu Sirohi
	Description 	: filtering contact records on the bacis of Name and Email, apply pagination 
					  according to page size and create four buttons .
*/

public class SearchContactController {
    public List <Contact> contactList {get;set;}
    public List <Contact> AllContactList {get;set;}
    public String inputSearch {get;set;}
    public Integer first {get;set;}
    public Integer last {get;set;}
    public String listSize {get;set;}
    Integer pageSize;
    
    public SearchContactController(){
       	AllContactList = [SELECT Id, Name, Email, AccountId, Phone, Type__c FROM Contact];
        contactList = AllContactList;
        listSize = '5';
        fillSelectedListSize();
    }
    
    public List <SelectOption> getFillList(){
        List <SelectOption> optionList = new List <SelectOption>();
        optionList.add(new SelectOption('0','All'));
        optionList.add(new SelectOption('5','5'));
        optionList.add(new SelectOption('10','10'));
        optionList.add(new SelectOption('15','15'));
        optionList.add(new SelectOption('20','20'));
        return optionList;
    } 
    
    public void fillSelectedListSize(){
        pageSize = Integer.ValueOf(listSize);
        first = 0;
        if(pageSize != 0){
            last =  pageSize;
            fillContacts(first, last);
        }
        else{
            contactList = AllContactList;
            last = AllContactList.size();
        }
    }
   
    public void fillContacts(Integer first, Integer last){
    	contactList = new List <Contact>();
        for(; first < last; first++){
           	contactList.add(AllContactList.get(first));     
        }
    }
     
    public void first(){
        if(contactList.size() < AllContactList.size()){
            fillContacts(0, pageSize);
            first = 0;
            last = pageSize;
        }
    }
      
    public void next(){
        if(last != AllContactList.size()){
            first = last;
            last = first + pageSize > AllContactList.size() ? AllContactList.size() : first + pageSize;
            fillContacts(first, last);
        }
    }
       
    public void previous(){
            first = first - pageSize < 0 ? 0 : first - pageSize;
            last = pageSize + first;
        	fillContacts(first, last );        	 
    }
    
    public void last(){
        System.debug(math.mod(AllContactList.size() , pageSize));
        first = math.mod(AllContactList.size() , pageSize) == 0 ? 
        AllContactList.size() - pageSize : 
        AllContactList.size() - math.mod(AllContactList.size(), pageSize); 
        fillContacts(first, AllContactList.size()); 
        last = AllContactList.size(); 
   }
    
    public void search(){
        AllContactList = [SELECT Id, Name, AccountId, Phone, Email, Type__c 
        FROM Contact 
        WHERE Name LIKE: '%' + inputSearch + '%' OR Email LIKE: '%' + inputSearch + '%'];
        first = 0;
        last = pageSize;
        fillContacts(0, pageSize > AllContactList.size() ? AllContactList.size() : pageSize == 0 ? 
        AllContactList.size() : pageSize);
    }
}