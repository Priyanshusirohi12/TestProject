public without sharing class PublicRedirectCtrl {
    
    public String session {get; set;}
    public String serverUrl {get; set;}
    public String recordId {get; set;}
    
    public PageReference navigatToPublicPageSecurely () {
        //return new PageReference (serverUrl);
        
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverUrl);
        request.setMethod('GET');
        HttpResponse resp = h.send(request);
        
        serverUrl = STring.valueOf (resp);
        //serverUrl = 'hello';
        return null;
        
    }
    
    public PageReference createUrl () {
     
         System.debug ('>>>>> made it to publi redirect controller');
        
        String USERNAME = 'loan.accel@badassdev.com';
        String PASSWORD = 'test12341';
        String endpoint = 'https://login.salesforce.com/services/Soap/u/41.0';
        ApexPages.currentPage().getParameters().put('recordId', recordId);
        
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        
        String body = '<?xml version="1.0" encoding="utf-8"?>';
        
        body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:partner.soap.sforce.com">';
        body += '<soapenv:Body>';
        body += '<urn:login>';
        body += '<urn:username>' + USERNAME + '</urn:username>';
        body += '<urn:password>' + PASSWORD + '</urn:password>';
        body += '</urn:login>';
        body += '</soapenv:Body>';
        body += '</soapenv:Envelope>';
        request.setBody(body);
        
        HttpResponse resp = h.send(request);
        
        Dom.XmlNode resultElmt = (resp.getBodyDocument().getRootElement())
            .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
            .getChildElement('loginResponse', 'urn:partner.soap.sforce.com')
            .getChildElement('result', 'urn:partner.soap.sforce.com');
        serverUrl = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com').getText().split('/services')[0];
        session = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com').getText();

        String retUrl = '&retURL=%2Fc%2FgreenDoorDownload.app';
        //String retUrl = 'https%3A%2F%2Ftcaccel2-dev-ed.lightning.force.com%2Fc%2FgreenDoorDownload.app';
        retUrl += EncodingUtil.urlDecode('?recordId=' + ApexPages.currentPage().getParameters().get('recordId'), 'utf-8');
        serverUrl = serverUrl + '/secur/frontdoor.jsp?sid=' + session + retUrl;
        session = EncodingUtil.urlEncode (session, 'utf-8');
        System.debug ('>>>>> serverUrl: ' + serverUrl + '/secur/frontdoor.jsp?sid=' +EncodingUtil.urlEncode (session, 'utf-8') + '&retURL=' + retUrl);
        return null;//new PageReference (serverUrl + '/secur/frontdoor.jsp?sid=' + session + '&retURL=' + retUrl);
        
        
        //return null;
    }
}