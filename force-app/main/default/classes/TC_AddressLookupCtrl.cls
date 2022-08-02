/**
 * Created on 1/1/18.
 */

public with sharing class TC_AddressLookupCtrl {
    public static final String GOOGLE_API_KEY = 'AIzaSyBwE_6jzFz1J-C5TP1Y_GLuIMZBuri6HxY';
    @AuraEnabled
    public static String getAddressAutoComplete(String input, String types) {
        try {
            String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input='
                + EncodingUtil.urlEncode(input, 'UTF-8')
                + '&types=' + types
                + '&components=country:us|country:ca'
                + '&key=' + GOOGLE_API_KEY;

            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(url);
            HttpResponse resp = h.send(req);
            return resp.getBody();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static String getGetPlaceInfoById(String placeId) {
        try {
            String url = 'https://maps.googleapis.com/maps/api/place/details/json?'
                + 'placeid=' + placeId
                + '&key=' + GOOGLE_API_KEY;
            System.debug(url);

            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(url);
            HttpResponse resp = h.send(req);
            return resp.getBody();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}