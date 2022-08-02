public class FileUploaderCtrl {
    
    
    @AuraEnabled
    public static String initPage () {

        //THIS NEEDS TO BE UPDATED TO A NON ADMIN USER AND NAMED CREDENTIALS
        String session;


        String USERNAME = '{!$Credential.Username}';
        String PASSWORD = '{!$Credential.Password}';

        System.debug ('checking user type - ' + UserInfo.getUserType());

        if (UserInfo.getUserType() == 'Guest') {
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            //String endpoint = 'https://test.salesforce.com/services/Soap/u/41.0';
            //String endpoint = 'https://tc-application-developer-edition.na35.force.com/public/Soap/u/42.0';
            request.setEndpoint('callout:SF_FileUpload');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            request.setHeader('SOAPAction', '""');
            
            String body = '<?xml version="1.0" encoding="utf-8"?>';
            
            body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:partner.soap.sforce.com">';
            //body += '<soapenv:Header>';
            //body += '<urn:LoginScopeHeader>';
            //body += '<urn:organizationId>00D410000006aXp</urn:organizationId>';
            //body += '</urn:LoginScopeHeader>';
            //body += '</soapenv:Header>';
            body += '<soapenv:Body>';
            body += '<urn:login>';
            body += '<urn:username>' + USERNAME + '</urn:username>';
            body += '<urn:password>' + PASSWORD + '</urn:password>';
            body += '</urn:login>';
            body += '</soapenv:Body>';
            body += '</soapenv:Envelope>';
            request.setBody(body);
            HttpResponse resp = h.send(request);
            System.debug ('### ' + resp.getBody());
            
            Dom.XmlNode resultElmt = (resp.getBodyDocument().getRootElement())
                .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                .getChildElement('loginResponse', 'urn:partner.soap.sforce.com')
                .getChildElement('result', 'urn:partner.soap.sforce.com');
            String serverUrl = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com').getText().split('/services')[0];
            session = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com').getText();
            
        } else {
            session = UserInfo.getSessionId();
        }
        return session;
    }
}