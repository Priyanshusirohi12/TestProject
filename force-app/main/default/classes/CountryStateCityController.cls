public class CountryStateCityController {
    public List<Country__c> countryList;
    public String countryValue{get;set;}
    public String stateValue{get;set;}
    public String cityValue{get;set;}
   	public List<SelectOption> stateOption;
    public List<SelectOption> cityOption;
    public Decimal  pinCodeValue{get;set;}
    public Map<String,Map<String,Map<String,Decimal >>> countryMap{get;set;}
	public CountryStateCityController()
    {
        countryList=[Select Name, State__c, City__c, Pincode__c from Country__c];
        System.debug(countryList);
         countryMap=new Map<String, Map<String, Map<String,Decimal >>>();
        for(Country__c country : countryList)
        {
         	Map<String, Map<String,Decimal >> stateMap;
            Map<String,Decimal > cityList;
            Decimal  pinCode=0;
            if(countryMap.containsKey(country.Name.toUpperCase())){
                stateMap=countryMap.get(country.Name.toUpperCase());
                if(stateMap.containsKey(country.state__c.toUpperCase())){
                    cityList=stateMap.get(country.state__c.toUpperCase());
                    if(cityList.containsKey(country.City__c.toUpperCase())){ 
                        pinCode=cityList.get(country.City__c);
                        //System.debug(pinCode);
                    }
                    else
                    {
                        pinCode=cityList.get(country.City__c);
                       // pincode='Priyanshu';
                         System.debug(pinCode);
                    }
                }else{
                    cityList=new Map<String,Decimal >();
                }
            	}else{
                    stateMap=new Map<String,Map<String,Decimal >>();
                    cityList=new Map<String,Decimal >();
                	}
            		pinCode=country.Pincode__c;
            		System.debug(pinCode);
            		cityList.put(country.city__c.toUpperCase(), pincode);
            		stateMap.put(country.state__c.toUpperCase(), cityList);
            		countryMap.put(country.Name.toUpperCase(), stateMap);
               }
        	System.debug(countryMap);
    }
    public List<SelectOption> getselectCountry()
    {
       List<SelectOption> countryOption =new List<SelectOption>();
        for(String country :countryMap.keySet())
        {
            countryOption.add(new SelectOption(country,country));
        }
        //System.debug(countryOption);
        return countryOption;
    }
    public void selectState()
    {
        System.debug(countryValue);
        if(String.isBlank(countryValue))    {
            stateOption.clear();
            cityOption.clear();
        }
        else{
            stateOption=new List<SelectOption>();
            cityOption=new List<SelectOption>();
            //System.debug('')
            for(String state : countryMap.get(countryValue).keySet())
            {
                //System.debug(state);
                stateOption.add(new SelectOption(state,state));
            }
        }
        	System.debug(stateOption);
            //return stateOption;
    }
    public List<SelectOption> getshowState()
    {
        return stateOption;
    }
    public void selectCity()
    {
         if(String.isBlank(stateValue)){
             cityOption.clear();
         }else{
             cityOption=new List<SelectOption>();
             for(String city : countryMap.get(countryValue).get(stateValue).keySet())
             {
                 System.debug(city);
                 cityOption.add(new SelectOption(city,city));
             }
         }
        //return cityOption 
    }
    public List<SelectOption> getshowCity()
    {
        return cityOption;
    }
    public void selectpinCode(){
        if(String.IsBlank(cityValue))
        {
            pinCodeValue=0;
        }
        else
        {
             pinCodeValue = countryMap.get(countryValue).get(stateValue).get(cityValue);
            System.debug(countryMap.get(countryValue).get(stateValue).get(cityValue));
            System.debug('@@@@'+pinCodeValue);
            System.debug('@@@@'+cityValue);
            
        }
    }
}