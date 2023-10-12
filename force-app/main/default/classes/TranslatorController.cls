public class TranslatorController {
    @AuraEnabled
    public static Map<String, Object> getLanguage(){
        HttP h = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setMethod('GET');
        setHeaders(request);
        request.setEndpoint('https://google-translate1.p.rapidapi.com/language/translate/v2/languages');
        //request.setHeader('accept-encoding' , 'application/gzip');
        //request.setHeader('x-rapidapi-host' , 'google-translate1.p.rapidapi.com');
        //request.setHeader('x-rapidapi-key', '926e88851emsh68e7b01a1ac54d7p1ccb00jsn0eac69d490db');
    
        request.setBody('q=&target=en');
       	HTTPResponse response = h.send(request);
        //response = getResponse('en');
        
        System.debug('get response or not '+response.getStatusCode());
        System.debug('response body '+response.getBody());
        Map<String, Object> jsonMap = (Map<String, Object>) System.Json.deserializeUntyped(response.getBody());
        system.debug('jsonBody '+jsonMap);
        Map<String, Object> languageMap = (Map<String, Object>) jsonMap.get('data');
        system.debug(languageMap);
        return languageMap;
    }
   
    @AuraEnabled
    public static Object translater(String q, String target, String source){
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setEndpoint('https://google-translate1.p.rapidapi.com/language/translate/v2');
        request.setMethod('POST');
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
       	//request.setHeader('accept-encoding','application/gzip');
        //request.setHeader('x-rapidapi-host','google-translate1.p.rapidapi.com');
        //request.setHeader('x-rapidapi-key', '926e88851emsh68e7b01a1ac54d7p1ccb00jsn0eac69d490db');
        setHeaders(request);  
        request.setBody('q='+q+'&target='+target+'&source='+source);
        
        System.debug('q='+q+'&target='+target+'&source='+source);
        HTTPResponse response = http.send(request);
        System.debug('get response or not '+response.getStatusCode());
        System.debug('response body '+response.getBody());
        Map<String, Object> jsonMap = (Map<String, Object>) System.Json.deserializeUntyped(response.getBody());
        Map<String, Object> dataMap = (Map<String, Object>) jsonMap.get('data');
        List<Object> dataList = (List<Object>) dataMap.get('translations');
        System.debug(dataList);
        
        return dataList.get(0);
    }
    public static void setHeaders(HTTPRequest request){
       	request.setHeader('accept-encoding','application/gzip');
        request.setHeader('x-rapidapi-host','google-translate1.p.rapidapi.com');
        request.setHeader('x-rapidapi-key', '926e88851emsh68e7b01a1ac54d7p1ccb00jsn0eac69d490db');
    }
}