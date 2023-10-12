//Apex callout for use of external application
public class CurrencyConverterClass {
    public static Decimal convertCurrencyToINR(Decimal eur){
        Decimal inr = 0.0;
        HTTP h = new HTTP();
        HTTPRequest request = new HTTPRequest();
       
        request.setEndpoint('http://api.exchangeratesapi.io/v1/latest?access_key=3d8ae80f2c88d135b5fe85644b70a9a2');
        request.setMethod('GET');
        
        HTTPResponse response = h.send(request);
        
        Map<String, Object> jsonBody = (Map<String, Object>)Json.deserializeUntyped(response.getBody());
        System.debug(jsonBody);
        
        Map<String, Object> mMap = (Map<String, Object>) jsonBody.get('rates');
        Decimal conversionRate = (Decimal)mMap.get('INR');
        inr = conversionRate * eur;
        System.debug('inr '+inr);
        return inr;
    }
}