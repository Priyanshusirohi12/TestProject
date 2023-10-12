@isTest
public class CountryStateCityControllerTest {
   @testSetup
    public static void fillCountry(){ 
        	List <Country__c> countryList= new List<Country__c>();
            countryList.add( new Country__c(Name='India',State__c='Rajasthan', City__c='Ajmer', Pincode__c =305001));
        	countryList.add( new Country__c(Name='India',State__c='Rajasthan', City__c='Ajmer', Pincode__c =305002));
        	countryList.add( new Country__c(Name='India',State__c='MP', City__c='Indor', Pincode__c =305003));
        	countryList.add( new Country__c(Name='India',State__c='MP', City__c='Bhopal', Pincode__c =305004));
        	
            Test.startTest();
            insert countryList;
            Test.stopTest();
        Map<String,Map<String,Map<String,Decimal >>> countryMap = new  Map<String,Map<String,Map<String,Decimal >>>();
        for(Country__c country : countryList){  
            Map<String,Map<String,Decimal >> stateMap;
            Map<String,Decimal > cityMap;
            Decimal  pinCode = 0;
            if(countryMap.containsKey(country.Name)){
                stateMap=countryMap.get(country.Name);
                if(stateMap.containsKey(country.state__c)){
                    cityMap=stateMap.get(country.state__c);
                    if(cityMap.containsKey(country.City__c)){ 
                        pinCode=cityMap.get(country.City__c);
                        //System.debug(pinCode);
                    }
                    else
                    {
                        pinCode=cityMap.get(country.City__c);
                       // pincode='Priyanshu';
                         System.debug(pinCode);
                    }
                }else{
                    cityMap=new Map<String,Decimal >();
                }
            	}else{
                    stateMap=new Map<String,Map<String,Decimal >>();
                    cityMap=new Map<String,Decimal >();
                	}
            		pinCode=country.Pincode__c;
            		System.debug(pinCode);
            		cityMap.put(country.city__c, country.Pincode__c);
            		stateMap.put(country.state__c, cityMap);
            		countryMap.put(country.Name, stateMap);  
        }
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        countryStateCityController.countryMap = countryMap;
        System.debug(countryMap.keySet());
        System.debug(countryMap.get(countryList.get(0).Name).keySet());
        System.debug(countryMap.get(countryList.get(0).Name).get(countryList.get(0).State__c).keySet());
        System.debug(countryMap.get(countryList.get(0).Name).get(countryList.get(0).State__c).get(countryList.get(0).City__c));
        System.debug(countryMap.get(countryList.get(0).Name).get(countryList.get(0).State__c).keySet());
            
        
    }
    @isTest
    public static void getCountryInsert(){
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        List<Country__c> countryList = countryStateCityController.countryList;
        System.assert(countryList.size() !=0);
        System.debug(countryList.size());   
    }
    
    @isTest
    public static void countryListOption(){
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        List<Country__c> countryList = countryStateCityController.countryList;
        System.assert(countryList.size() !=0);
        System.debug(countryList.size());
        countryStateCityController.getselectCountry();    
    }
   
    @isTest
    public static void stateList(){
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        List<Country__c> countryList = countryStateCityController.countryList;
        System.assert(countryList.size() !=0);
        System.debug(countryList.size());
        countryStateCityController.getshowState();
        
    }
    
    @isTest
    public static void cityListOption(){
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        List<Country__c> countryList = countryStateCityController.countryList;
        System.assert(countryList.size() !=0);
        System.debug(countryList.size());
        countryStateCityController.getshowCity();    
    }
    
     @isTest
    public static void stateListFill(){
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        List<Country__c> countryList = countryStateCityController.countryList;
         Map<String,Map<String,Map<String,Decimal >>> countryMap = new  Map<String,Map<String,Map<String,Decimal >>>();
        for(Country__c country : countryList){  
            Map<String,Map<String,Decimal >> stateMap;
            Map<String,Decimal > cityMap;
            Decimal  pinCode=0;
            if(countryMap.containsKey(country.Name)){
                stateMap=countryMap.get(country.Name);
                if(stateMap.containsKey(country.state__c)){
                    cityMap=stateMap.get(country.state__c);
                    if(cityMap.containsKey(country.City__c)){ 
                        pinCode=cityMap.get(country.City__c);
                        //System.debug(pinCode);
                    }
                    else
                    {
                        pinCode=cityMap.get(country.City__c);
                       // pincode='Priyanshu';
                         System.debug(pinCode);
                    }
                }else{
                    cityMap=new Map<String,Decimal >();
                }
            	}else{
                    stateMap=new Map<String,Map<String,Decimal >>();
                    cityMap=new Map<String,Decimal >();
                	}
            		pinCode=country.Pincode__c;
            		System.debug(pinCode);
            		cityMap.put(country.city__c, pincode);
            		stateMap.put(country.state__c, cityMap);
            		countryMap.put(country.Name, stateMap);
            
            
        }
        System.assert(countryList.size() !=0);
        System.debug(countryList.size());
        countryStateCityController.countryMap =countryMap;
        countryStateCityController.countryValue= '';
        countryStateCityController.stateOption = new List<SelectOption>();
        countryStateCityController.cityOption = new List<SelectOption>();
        countryStateCityController.countryValue = '';
        if(countryStateCityController.countryValue.equals('')){
            countryStateCityController.selectState();
            countryStateCityController.countryValue = countryList.get(0).Name;
            //System.debug('123456 '+countryMap.get(countryList.get(0).Name).keySet());
        } 
        if(!countryStateCityController.countryValue.equals('')){
            countryStateCityController.selectState();
            //System.debug('1212 '+countryList.get(0).Name);
            //System.debug('123456 '+countryMap.get(countryList.get(0).Name).keySet());
            countryStateCityController.countryValue = '';
        } 
        
        
    } 
    
    /*@isTest
    public static void cityListFill(){
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        List<Country__c> countryList = countryStateCityController.countryList;
        System.assert(countryList.size() !=0);
        System.debug(countryList.size());
        countryStateCityController.stateValue= '';
        countryStateCityController.cityOption = new List<SelectOption>();
        countryStateCityController.stateOption = new List<SelectOption>();
        
        if(countryStateCityController.stateValue.equals('')){
            countryStateCityController.cityOption.clear();
            countryStateCityController.selectCity();
            countryStateCityController.stateValue = countryList.get(0).State__c;
        } 
        if(!countryStateCityController.stateValue.equals('')){
            countryStateCityController.cityOption = new List<SelectOption>();
            Map<String,Map<String,Map<String,Decimal >>> countryMap = new  Map<String,Map<String,Map<String,Decimal >>>(); 
            Map<String,Map<String,Decimal >> stateMap = new  Map<String,Map<String,Decimal >>();
            Map<String,Decimal > cityMap = new  Map<String,Decimal >();
            cityMap.put('Ajmer',305001);
            cityMap.put('Jaipur',305002);
            stateMap.put('Rajasthan',cityMap);
            countryMap.put('India',stateMap);
            System.debug('gdfgdfgdf '+countryMap.get('India').get('Rajasthan').keySet());
        	countryStateCityController.countryMap =countryMap;
            countryStateCityController.selectCity();  
            countryStateCityController.stateValue = '';
        }
        
    }
    */
    @isTest
    public static void pincodeFill(){
        CountryStateCityController countryStateCityController = new CountryStateCityController();
        List<Country__c> countryList = countryStateCityController.countryList;
        System.assert(countryList.size() !=0);
        System.debug(countryList.size());
        countryStateCityController.cityValue= '';

        if(countryStateCityController.cityValue.equals('')){
            countryStateCityController.selectpinCode();
            countryStateCityController.cityValue = countryList.get(0).City__c;
        } 
        if(!countryStateCityController.cityValue.equals('')){
            Map<String,Map<String,Map<String,Decimal>>> countryMap = new  Map<String,Map<String,Map<String,Decimal>>>(); 
            Map<String,Map<String,Decimal>> stateMap = new  Map<String,Map<String,Decimal>>();
            Map<String,Decimal> cityMap = new  Map<String,Decimal>();
            cityMap.put('Ajmer',305001);
            cityMap.put('Jaipur',305002);
            stateMap.put('Rajasthan',cityMap);
            countryMap.put('India',stateMap);
        	countryStateCityController.countryMap =countryMap;
            countryStateCityController.selectpinCode();  
            countryStateCityController.cityValue = '';
        }
    }
}