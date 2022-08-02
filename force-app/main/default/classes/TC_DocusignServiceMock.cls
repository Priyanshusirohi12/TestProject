/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-20.
 * Description: 
 */

public class TC_DocusignServiceMock implements HttpCalloutMock {
    public HTTPResponse respond (HTTPRequest req) {
        // Create a fake response env
        if(req.getEndpoint().contains('templates')){
            HttpResponse res = new HttpResponse ();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"envelopeTemplates": [{"templateId": "sample string 1", "name": "sample string 2"}]}');
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }else if(req.getEndpoint().contains('envelopes') && !req.getEndpoint().contains('documents')){
            HttpResponse res2 = new HttpResponse ();
            res2.setHeader('Content-Type', 'application/json');
            res2.setBody('{"envelopeId": "sample string 1","uri": "sample string 2","statusDateTime": "sample string 3","status": "sample string 4"}');
            res2.setStatusCode(201);
            res2.setStatus('OK');
            return res2;
        } else if(req.getEndpoint().contains('documents')) {
            HttpResponse res3 = new HttpResponse ();
            res3.setHeader('Content-Type', 'application/json');
            res3.setBody('{"envelopeId": "sample string 1","uri": "sample string 2","statusDateTime": "sample string 3","status": "sample string 4"}');
            res3.setStatusCode(200);
            res3.setStatus('OK');
            return res3;
        } else if(req.getEndpoint() == 'callout:test') {
            System.debug('>>>>> Inside userinfo mock');
            HttpResponse res4 = new HttpResponse ();
            res4.setHeader('Content-Type', 'application/json');
            res4.setBody('{"envelopeId": "sample string 1","uri": "sample string 2","statusDateTime": "sample string 3","status": "sample string 4"}');
            res4.setStatusCode(200);
            res4.setStatus('OK');
            return res4;
        } else return new HttpResponse();

    }
}