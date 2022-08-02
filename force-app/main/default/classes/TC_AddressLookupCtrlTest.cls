@isTest
private class TC_AddressLookupCtrlTest {
	testMethod
    static void testPlaceSearch () {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GoogleAPIPlaceSearchResult');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
    	Test.setMock(HttpCalloutMock.class, mock);
 		
        Test.startTest();
        
        TC_AddressLookupCtrl.getAddressAutoComplete('test', null);
        TC_AddressLookupCtrl.getGetPlaceInfoById ('test');
        Test.stopTest();
        
    }
}