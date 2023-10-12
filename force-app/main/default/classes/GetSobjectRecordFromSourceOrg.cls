@RestResource(urlMapping='/v1/GetSobjectRecordFromSourceOrg/*')
global class GetSobjectRecordFromSourceOrg {
    @HTTPPost
    global static void saveRecords(){
        
        RestRequest request = RestContext.request;
        String requestBody = request.requestBody.toString();
        System.debug(requestBody);
        //Map<String, Object> jsonBody = (Map<String,Object>)JSON.deserializeUntyped(requestBody);
        //System.debug('json '+ jsonBody);
    }
}