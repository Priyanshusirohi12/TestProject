@RestResource(urlMapping='/v1/GetRouteStationRecordsFromSourceOrg/*')
global class GetRouteStationRecordsFromSourceOrg {
    @HTTPPost
    global static void saveRecords(){
        String value = 'Ajmer';
        RestRequest request = RestContext.request;
        String requestBody = request.requestBody.toString();
        System.debug(requestBody);
        //Map<String, Object> jsonBody = (Map<String,Object>)JSON.deserializeUntyped(requestBody);
        //System.debug('json '+ jsonBody);
    }
    
}