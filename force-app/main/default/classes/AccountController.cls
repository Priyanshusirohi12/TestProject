public with sharing class AccountController {
    public AccountController() {

    }
    @AuraEnabled(cacheable=true)
	public static List<DataSet> getAllAccountsByRating(){
	List<AggregateResult> result =  [Select Count(Id) cnt, Rating from Account  group by Rating limit 10];
	List<DataSet> dataSet = new List<DataSet>();
	for(AggregateResult ar:result){
	String status =  (String)ar.get('Rating') ;
	Integer total =(Integer)ar.get('cnt');
	dataSet.add(new DataSet(status ,total));
	}
	System.debug('dataSet'+dataSet);
	return dataSet ;
	}
public class DataSet{
public DataSet(String label ,Integer count){
this.label  = label ;
this.count = count ;
}
@AuraEnabled
public String label {get;set;}
@AuraEnabled
public Integer  count {get;set;}
}
}