global class MockHttpXMLResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
            
        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        //res.setBody('<soap:Body><AddressValidateResponse xmlns="http://tempuri.org/"><AddressValidateResult><ResponseCode>0</ResponseCode><LogMessage /><ErrorMessage /></AddressValidateResult></AddressValidateResponse></soap:Body></soap:Envelope><?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><AddApplicationResponse xmlns="http://tempuri.org/"><AddApplicationResult><ResponseCode>0</ResponseCode><LogMessage /><AppNumber>40915092</AppNumber><AddressLookUp><ResponseCode>0</ResponseCode><LogMessage /><LesseeAddError>false</LesseeAddError><BillingAddError>false</BillingAddError><Signer1AddError>false</Signer1AddError><Signer2AddError>false</Signer2AddError><AddrError>false</AddrError></AddressLookUp></AddApplicationResult></AddApplicationResponse></soap:Body>');        
        //res.setBody('<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><AddApplicationResponse xmlns="http://tempuri.org/"><AddApplicationResult><SessionID>12345</SessionID><ResponseCode>0</ResponseCode><LogMessage /><AppNumber>40915092</AppNumber><AddressLookUp><ResponseCode>0</ResponseCode><LogMessage /><LesseeAddError>false</LesseeAddError><BillingAddError>false</BillingAddError><Signer1AddError>false</Signer1AddError><Signer2AddError>false</Signer2AddError><AddrError>false</AddrError></AddressLookUp></AddApplicationResult></AddApplicationResponse></soap:Body></soap:Envelope>');

        String body = '';
        body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:partner.soap.sforce.com">';
  		body += '<soapenv:Body>';
    	body += '<urn:loginResponse>';
    	body += ' <urn:result>';
    	body += ' <urn:serverUrl>';
    	body += 'http://foo.com/services/bar';
    	body += '</urn:serverUrl>';
    	body += '<urn:sessionId>';
    	body += '</urn:sessionId>';
    	body += '</urn:result>';
    	body += '</urn:loginResponse>';
    	body += '</soapenv:Body>';
    	body += '</soapenv:Envelope>';

        res.setBody(body);
        
        
        res.setStatusCode(200);
        return res;
    }
}