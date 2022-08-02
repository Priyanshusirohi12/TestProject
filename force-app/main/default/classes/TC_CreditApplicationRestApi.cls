@RestResource(urlMapping='/application/create')
global with sharing class TC_CreditApplicationRestApi  {

    @HttpGet
    global static CreditAppRestResponse ping() {
        CreditAppRestResponse resp = new CreditAppRestResponse();
        resp.message = 'Hello World';
        resp.isSuccess = true;

        return resp;
    }

    @HttpPost
    global static CreditAppRestResponse create() {

    //create savepoint and process data
    Savepoint sp = Database.setSavepoint();
    RestResponse restResp = RestContext.response;
    CreditAppRestResponse resp = new CreditAppRestResponse();

        try {
            //check auth
            TC_Credit_Application_API_Setting__mdt setting = [SELECT Id, Access_Token__c FROM TC_Credit_Application_API_Setting__mdt LIMIT 1];
            String xAuthToken = RestContext.request.headers.get('X-Auth-Token');

            if (xAuthToken != setting.Access_Token__c) {
                throw new CreditApplicationRestApiAccessException ('Unauthorized');
            }

            TC_CreditApplication app = (TC_CreditApplication) JSON.deserialize(RestContext.request.requestBody.toString(), TC_CreditApplication.class);
            TC_ICreditApplicationMapper mapper = new TC_CreditApplicationMapper ();

            app = mapper.parseApplicationData (RestContext.request.requestBody);
            resp.appSystemId = app.systemId;
            resp.borrowerSystemId = app.borrower.systemId;
            resp.isSuccess = true;
            resp.message = 'SUCCESS';// + RestContext.request.requestBody.toString();

        } catch (System.JSONException je) {
            Database.rollback(sp);
            restResp.statusCode = 400;
            resp.message =  je.getMessage() + ' - ' + je.getStacktraceString() + ' - ' + je.getTypeName();
            resp.isSuccess = false;

        } catch (CreditApplicationRestApiAccessException ae) {
            restResp.statusCode = 401;
            resp.message =  'Something went terribly wrong...';
            resp.isSuccess = false;
        } catch (Exception e) {
            Database.rollback(sp);
            restResp.statusCode = 500;
            resp.message =  e.getMessage() + ' - ' + e.getStacktraceString() + ' - ' + e.getTypeName();
            resp.isSuccess = false;
        }

        return resp;
    }

    global class CreditAppRestResponse {
        String appSystemId;
        String borrowerSystemId;
        @testVisible
        Boolean isSuccess;
        String message;
    }

    global class CreditApplicationRestApiAccessException extends Exception {}
}