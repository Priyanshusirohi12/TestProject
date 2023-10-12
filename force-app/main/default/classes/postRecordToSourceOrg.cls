@RestResource(urlMapping='/v1/postRecordToSourceOrg/*')
global class postRecordToSourceOrg {
    public static String location;
    public static String destination;
    public static Decimal totalDistance = 0.0;
    public static Boolean checkLocation = false;
    @HTTPPost
    global static Map<String,String> saveRecords(){
        String route;
        Decimal distance;
        Set<Id> RouteIdSet = new Set<Id>();
        RestRequest request = RestContext.request;
       	RestResponse response = RestContext.response;
        String requestBody = request.requestBody.toString();
       	JSONParser parser =JSON.createParser(requestBody);
        Integer i = 0;
        while(i < 3){
            parser.nextValue();
            if(i == 1){
               location =  parser.getText();
            }else if(i ==2){
                destination = parser.getText();
            }
            i++;
        }
        List<Route_Station__c> routeStationList =  [SELECT Name, Distance__c,Previous_Station__c, Main_Route__r.Name 
                                                    FROM Route_Station__c];
        
        for(Route_Station__c routeStation : routeStationList){
            if(routeStation.Name == location || routeStation.Name == destination){
            	RouteIdSet.add(RouteStation.Main_Route__c);   
            }
        }
        
        Map<Id,Route_Station__c> routeStationMap = new Map<Id,Route_Station__c>([SELECT Id, Name, Distance__c, Main_Route__r.Name,  
                                              									 Previous_Station__c FROM Route_Station__c
                                              									 WHERE Main_Route__c =: RouteIdSet]);
        
        for(Route_Station__c routeStationObject : routeStationMap.values()){
            if(routeStationObject.Previous_Station__c != null){
                if(routeStationObject.Name == destination){
                  checkLocationValue(routeStationMap, routeStationObject); 
                }
            }
        }
        for(Route_Station__c routeStationObject : routeStationList){
            if(checkLocation){
                if(destination == routeStationObject.Name){
                    route = routeStationObject.Main_Route__r.Name;
                	distance = checkPreviousStation(routeStationMap, routeStationObject, true);
                }
         	}
            if(!checkLocation){
              	if(location == routeStationObject.Name){
                    distance = checkPreviousStation(routeStationMap, routeStationObject, false);
                    route = routeStationObject.Main_Route__r.Name;
                }
           	}
		}
        if(distance != null && route != null){
            Map<String,String> recordMap = new Map<String, String>();
            recordMap.put('route', route);
            recordMap.put('totalDistance',String.valueOf(distance));
            return recordMap;
        }else{
            return null;
        }
    }
    
    public static Decimal checkPreviousStation(Map<Id, Route_Station__c> routeStationMap, Route_Station__c routeStationObject, Boolean check){
        totalDistance = totalDistance + routeStationObject.Distance__c;
       	Route_Station__c previousStation = routeStationMap.get(routeStationObject.Previous_Station__c);
        if(routeStationMap.containsKey(previousStation.Previous_Station__c) && previousStation.Name != location && check){
            checkPreviousStation(routeStationMap, previousStation, true);
        }
        else if(routeStationMap.containsKey(previousStation.Previous_Station__c) && previousStation.Name != destination && check == false){
            checkPreviousStation(routeStationMap, previousStation, false);    
        }
        return totalDistance;
    }
    
    public static void checkLocationValue(Map<Id, Route_Station__c> routeStationMap, Route_Station__c routeStationObject){
       	Boolean check = false;  
        Route_Station__c previousStation = routeStationMap.get(routeStationObject.Previous_Station__c);
        if(previousStation.Name == location){
            checkLocation =  true;  
        }   
        if(routeStationMap.containsKey(previousStation.Previous_Station__c)){
            checkLocationValue(routeStationMap, previousStation);
        }
    }   
}