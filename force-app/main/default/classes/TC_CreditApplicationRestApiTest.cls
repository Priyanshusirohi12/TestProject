@isTest
private class TC_CreditApplicationRestApiTest {
    
    static testMethod void testDoPostErrorNoAuth() {
        
        StaticResource reqBodyResource = [SELECT Id, Body FROM StaticResource WHERE Name = 'newAppJsonRequest' LIMIT 1];
        

        RestRequest req = new RestRequest(); 
        req.requestBody = reqBodyResource.Body;
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/application/create';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TC_CreditApplicationRestApi.CreditAppRestResponse results = TC_CreditApplicationRestApi.create();
        
        System.assert(!results.isSuccess); //auth required
        System.assert(res.statusCode == 401);
        
    }
    
    static testMethod void testDoPostBadData() {
        
        StaticResource reqBodyResource = [SELECT Id, Body FROM StaticResource WHERE Name = 'newAppJsonRequestBad' LIMIT 1];
        TC_Credit_Application_API_Setting__mdt setting = [SELECT Id, Access_Token__c FROM TC_Credit_Application_API_Setting__mdt LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestBody = reqBodyResource.Body;
        req.addHeader('X-Auth-Token', setting.Access_Token__c);
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/application/create';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TC_CreditApplicationRestApi.CreditAppRestResponse results = TC_CreditApplicationRestApi.create();
        
        System.assert(!results.isSuccess);
        System.assert(res.statusCode == 400);

        
    }
    
    static testMethod void testDoPostSuccess() {
        
        StaticResource reqBodyResource = [SELECT Id, Body FROM StaticResource WHERE Name = 'newAppJsonRequest' LIMIT 1];
        TC_Credit_Application_API_Setting__mdt setting = [SELECT Id, Access_Token__c FROM TC_Credit_Application_API_Setting__mdt LIMIT 1];

        Test.startTest();

        RestRequest req = new RestRequest(); 
        req.requestBody = reqBodyResource.Body;
        req.addHeader('X-Auth-Token', setting.Access_Token__c);
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/application/create';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TC_CreditApplicationRestApi.CreditAppRestResponse results = TC_CreditApplicationRestApi.create();
        
        System.assert(results.isSuccess);
        Test.stopTest();
        
    }
    
}