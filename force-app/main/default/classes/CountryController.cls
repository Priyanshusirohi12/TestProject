public class CountryController {
    public Map<Id,Country__c> countryMap;
    public CountryController(){
        countryMap= new Map<Id,Country__c>([SELECT Id, Name, State__c, City__c, Pincode__c FROM Country__c]);
    }
}
   /* public List<SelectOption> getsetCountry(){
        List<SelectOption> countryList=new List<SelectOption>();
		for(aggregateResult country : [Select Name from Country__c GROUP BY Name]){
            CountryList.add(new SelectOption((String)country.get('Name'), (String)country.get('Name')));
        }
        return countryList;
    }
    public List<SelectOption> getsetState(){
       	List<SelectOption> stateList= new List<SelectOption>();
        for(AggregateResult state : [Select State__c from Country__c WHERE Name =: countryName GROUP BY State__c]){
            stateList.add(new SelectOption((String)state.get('State__c'),(String)state.get('State__c')));
        }
        return stateList;
        
    }
    public List<SelectOption> getsetCity(){
       	List<SelectOption> cityList= new List<SelectOption>();
        for(AggregateResult city : [Select City__c from Country__c WHERE State__c= :stateName GROUP BY City__c]){
            cityList.add(new SelectOption((String)city.get('City__c'),(String)city.get('City__c')));
        }
        return cityList;    
    }
       public void setPincode(){
       	List<Country__c> pincodeList=[SELECT Pincode__c FROM Country__c where City__c=:cityName];
          
        for(Country__c pincode : pincodeList ){
            {
                pincodeName=(Integer)pincode.pinCode__c;
                System.debug(pincodeName);
            	break;
            }
        }
   }
    public void onChange()
    {
        
    }
    public void onChange2()
    {
        
    }
    public void onChange3()
    {
        
    }
    public void onChange4()
    {
        
    }*/