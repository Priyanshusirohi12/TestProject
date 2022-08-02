/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-20.
 * Description: 
 */

public without sharing class TC_DocusignService {

    private static TC_DocusignAccount defaultAcc;
    private static TC_DocusignAccountInfo accInfo;
    private static String restCallout;
    private static String accountCallout;

    /**
     * @description used to create the callout String for the Docusign
     *           named credentials
     *
     * @param callType, dictates which Named Credential to use for each callout;
     *                  either 'Account' for https://account-d.docusign.com/oauth/userinfo
     *                  or 'REST' for https://demo.docusign.net/restapi/v2.1/
     *
     * @param userId, used to grab the partner Id settings on the Webhook callback
     *
     * @return docusignCallout, callout String to be used as base in each HttpRequest.setEndpoint assignment
     */
    public static String getCalloutString(String callType, String userId) {

        System.debug('userId' + userId);
        String userLicense = getUserLicense(userId);
        System.debug('userLicense: ' + userLicense);
        List<Docusign_User_Setting__mdt> docUserSettingList = new List<Docusign_User_Setting__mdt>();
        Docusign_User_Setting__mdt docUserSetting = new Docusign_User_Setting__mdt();
        List<User> userList = new List<User>();
        String docusignCallout;

        if(userLicense != null && userLicense.contains('Community')) {
            String partnerId;
            try{
                if(userId == null) {
                    userList = [SELECT Id, Partner_Account_Id__c FROM User WHERE Id = :UserInfo.getUserId()];
                    if(!userList.isEmpty()) {
                        partnerId = userList[0].Partner_Account_Id__c;
                    }
                } else {
                    userList = [SELECT Id, Partner_Account_Id__c FROM User WHERE Id = :userId];
                    if(!userList.isEmpty()) {
                        partnerId = userList[0].Partner_Account_Id__c;
                    }
                }
            } catch (Exception e) {
                throw new TC_DocusignServiceException('Partner ID not found.');
            }
            System.debug('Partner Id ' + partnerId);
            try{
                if(!Test.isRunningTest()) {
                    docUserSettingList = [SELECT Id, Partner_ID__c, Account_Named_Credential__c, REST_Named_Credential__c FROM Docusign_User_Setting__mdt WHERE Partner_ID__c = :partnerId];
                    if(!docUserSettingList.isEmpty()) {
                        docUserSetting = docUserSettingList[0];
                    }
                }
            }catch(Exception e) {
                throw new TC_DocusignServiceException('DocuSign user settings not found.');
            }
        } else {
            try{
                docUserSettingList = [SELECT Id, Single_Tenant_Credentials__c, Account_Named_Credential__c, REST_Named_Credential__c FROM Docusign_User_Setting__mdt WHERE Single_Tenant_Credentials__c = TRUE];
                if(!docUserSettingList.isEmpty()) {
                    docUserSetting = docUserSettingList[0];
                }
            } catch(Exception e) {
                throw new TC_DocusignServiceException('Docusign settings not found.');
            }
        }

        if(Test.isRunningTest()) {
            docUserSetting.Account_Named_Credential__c = 'test';
            docUserSetting.REST_Named_Credential__c = 'test';
        }

        if(callType == 'Account') {
            docusignCallout = 'callout:' + docUserSetting.Account_Named_Credential__c;
        } else if (callType == 'REST') {
            docusignCallout = 'callout:' + docUserSetting.REST_Named_Credential__c;
        }

        return docusignCallout;
    }

    /**
     * @description used to retrieve the account info from the DocuSign API
     *
     * @return accInfo,  TC_DocusignAccountInfo object that contains the returned account information
     *                   from DocuSign
     */

    public static TC_DocusignAccountInfo getAccountInfo () {
        if (accInfo == null) {
            Http h = new Http ();

            HttpRequest req = new HttpRequest ();
            req.setMethod('GET');
            String call = getCalloutString('Account', null);
            req.setEndpoint (call);
            System.debug('>>>>> ' + req.getEndpoint());

            HttpResponse resp = h.send(req);

            System.debug (resp.getBody());

            if (resp.getStatusCode() == 200) {
                accInfo = (TC_DocusignAccountInfo) JSON.deserialize(resp.getBody(), TC_DocusignAccountInfo.class);

                defaultAcc = new TC_DocusignAccount ();

                if (accInfo.accounts != null) {
                    for (TC_DocusignAccount da: accInfo.accounts) {
                        if (da.is_default)
                            defaultAcc = da;
                    }
                }

            } else {
                throw new TC_DocusignServiceException ('Callout error : ' + resp.getStatus());
            }
        }

        return accInfo;
    }

    /**
     * @description used to either return the account info stored in the global variable defaultAcc
     *              or call the method getAccountInfo() if the account info is null
     *
     * @return defaultAcc, the DocuSign account info for the default account
     */

    public static TC_DocusignAccount getDefaultAccount () {
        if (defaultAcc == null) getAccountInfo();
        return defaultAcc;
    }

    /**
     * @overview main method to send the DocuSign envelope to the server
     *
     * @param env, DocuSign envelope passed in from the component controller
     *
     * @return env, response envelope from DocuSign containing envelope Id
     */
    public static TC_DocusignEnvelope createEnvelopeDraft (TC_DocusignEnvelope env) {


        Http h = new Http ();
        HttpRequest req = new HttpRequest ();
        String call;
        if(restCallout == null){
            call = getCalloutString('REST', null);
        }
        if(defaultAcc == null){
            req.setEndpoint(call + '/accounts/' + getDefaultAccount().account_id + '/envelopes');
        } else {
            req.setEndpoint(call + '/accounts/' + defaultAcc.account_id + '/envelopes');
        }
        System.debug('>>>>>>> defAccId' + defaultAcc.account_id);
        req.setMethod('POST');
        req.setBody(JSON.serialize(env));
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Content-Disposition', 'form-data');

        System.debug('createEnvelope request - ' + req);
        System.debug(req.getBody());

        HttpResponse resp = h.send(req);

        System.debug (resp.getBody());

        if (resp.getStatusCode() == 201) {
            env = (TC_DocusignEnvelope) JSON.deserialize(resp.getBody(), TC_DocusignEnvelope.class);
        } else {
            Map <String, Object> respObj = (Map <String, Object>) JSON.deserializeUntyped(resp.getBody());
            throw new TC_DocusignServiceException ('Callout error : '
                    + resp.getStatus()
                    + ' - ' + String.valueOf(respObj.get('errorCode'))
                    + ' - ' + String.valueOf(respObj.get('message')));
        }

        return env;
    }

    /**
     * @description retrieves DocuSign templates associated with given account based on the number of
     *              related list items that are available for submission (ie 2 equipment and 1 fee).
      *             These numbers are determined in the description of templates themselves
     *
     * @param parentId, Id of Opportunity record where the envelope is being sent from
     * @param numEquipment, number of equipment related to given opportunity
     * @param numFees, number of fees related to given opportunity
     *
     * @return templateMap, map of all available templates available with a key of the template name
     *                      and value of the template Id
     */
    public static Map<String, String> getTemplates(String parentId, Integer numEquipment, Integer numFees) {

        if(defaultAcc == null) {
            defaultAcc = getDefaultAccount();
        }
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        restCallout = TC_DocusignService.getCalloutString('REST', null);
        req.setEndpoint(restCallout + '/accounts/' + defaultAcc.account_id + '/templates');

        HttpResponse resp = h.send(req);
        System.debug(resp.getBody());
        System.debug(resp.getStatusCode());

        TC_DocusignEnvelopeTemplate temps;
        if(resp.getStatusCode() == 200){
            temps = (TC_DocusignEnvelopeTemplate) JSON.deserialize(resp.getBody(), TC_DocusignEnvelopeTemplate.class);
        } else {
            throw new TC_DocusignServiceException('Callout error: ' + resp.getStatus());
        }

        Map<String, String> templateMap = new Map<String, String>();
        for(TC_DocusignEnvelopeTemplate.EnvelopeTemplate et : temps.envelopeTemplates) {
            if(et.description == null || et.description == '') {
                templateMap.put(et.name, et.templateId);
            }
            System.debug('numEquipment ' + et.description);
            System.debug('numFees ' + et.description);

            if(et.description != null) {
                if(et.description.contains('<' + numEquipment + 'equipment>') && !et.description.contains('fee')){
                    templateMap.put(et.name, et.templateId);
                }
                if(!et.description.contains('equipment') && et.description.contains('<' + numFees + 'fee>')) {
                    templateMap.put(et.name, et.templateId);
                }
                if(et.description.contains('<' + numEquipment + 'equipment>') && et.description.contains('<' + numFees +'fee>')) {
                    templateMap.put(et.name, et.templateId);
                }
            }
        }

        return templateMap;
    }

    /**
     * @description retrieves the names and Ids of each document within a completed DocuSign envelope and calls
     *              the saveSeparateDocs() method to save
     *
     * @param envelopeId, DocuSign envelope Id from which to retrieve the completed document information
     * @param oppId, Salesforce opportunity Id
     * @param accId, DocuSign user account Id
     * @param userId, current community user Id
     */
    @Future (Callout=true)
    public static void getDocumentInfo (String envelopeId, String oppId, String accId, String userId) {
        Http h = new Http ();
        HttpRequest req = new HttpRequest ();
        String callout = getCalloutString('REST', userId);
        req.setEndpoint(callout + '/accounts/' + accId + '/envelopes/' + envelopeId + '/documents');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse resp = h.send(req);

        System.debug(resp.getStatus());
        //System.debug(resp.getBody());

        if(resp.getStatusCode() == 200) {
            TC_DocusignEnvelope docsEnv = new TC_DocusignEnvelope();
            docsEnv = (TC_DocusignEnvelope) JSON.deserialize(resp.getBody(), TC_DocusignEnvelope.class);
            List<String> docInfo = new List<String>();
            System.debug('docsEnv ' + docsEnv);
            if(docsEnv.envelopeDocuments != null) {
                for(TC_DocusignEnvelope.EnvelopeDocument envDoc : docsEnv.envelopeDocuments) {
                    docInfo.add(removeFileType(envDoc.name) + '_____' + envDoc.documentId);
                }

                saveSeparateDocs(envelopeId, oppId, accId, docInfo, userId);
            }
        } else {
            throw new TC_DocusignServiceException('Error parsing returned documents: ' + resp.getStatus());
        }
    }

    /**
     * @description loops through each document in the envelope and makes a callout to retrieve the document bodies
     *              and inserts these documents onto the parent opportunity record.
     *
     * @param envelopeId, DocuSign user account Id
     * @param oppId, Salesforce opportunity Id
     * @param accId, DocuSign user account Id
     * @param docInfo, list of strings containing the name and Id of each document in the envelope
     * @param userId, current community user Id
     */
    public static void saveSeparateDocs (String envelopeId, String oppId, String accId, List<String> docInfo, String userId) {

        String callout = getCalloutString('REST', userId);
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<String> cvIdList = new List<String>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();

        List<String> docNameId = new List<String>();
        for(String doc : docInfo) {
            docNameId = doc.split('_____');
            if(docNameId[1] != 'certificate') {
                System.debug(docNameId);
                Http h = new Http ();
                HttpRequest req = new HttpRequest ();
                req.setEndpoint(callout + '/accounts/' + accId + '/envelopes/' + envelopeId + '/documents/' + docNameId[1]);
                req.setMethod('GET');
                req.setHeader('Content-Type', 'application/json');

                HttpResponse resp = h.send(req);

                System.debug(resp.getStatus());
                //System.debug(resp.getBody());

                if(resp.getStatusCode() == 200) {
                    cvList.add(new ContentVersion(
                            VersionData = resp.getBodyAsBlob(),
                            Title = docNameId[0] + ' - ' + System.today().format(),
                            PathOnClient = docNameId[0] + '.pdf'));
                } else {
                    throw new TC_DocusignServiceException('Error saving returned documents: ' + resp.getStatus());
                }
            }
        }

        insert cvList;

        for(ContentVersion c : cvList) {
            cvIdList.add(c.Id);
        }

        for(ContentDocument cd : [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId IN :cvIdList]) {
            if (!Test.isRunningTest()) {
                cdlList.add(new ContentDocumentLink (ContentDocumentId = cd.Id, LinkedEntityId = oppId, ShareType = 'I'));
            }
        }

        if(!cdlList.isEmpty()) {
            insert cdlList;
        }
    }


    /**
     * @description
     *
     * @param envelopeId, DocuSign envelope Id
     * @param oppId, Opportunity Id of where the envelope submission was from
     * @param accId, DocuSign account Id
     */
    @Future (Callout=true)
    public static void saveDocuments (String envelopeId, String oppId, String accId, String userId) {
        Http h = new Http ();
        HttpRequest req = new HttpRequest ();
        String callout = getCalloutString('REST', userId);
        req.setEndpoint(callout + '/accounts/' + accId + '/envelopes/' + envelopeId + '/documents/combined');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse resp = h.send(req);

        System.debug(resp.getStatus());
        System.debug(resp.getBody());

        //System.debug ('saveDocuments response - ' + resp.getBody());

        if (resp.getStatusCode() == 200) {
            String title = 'Document.pdf';

            ContentVersion cv = new ContentVersion();
            cv.VersionData = resp.getBodyAsBlob();
            cv.Title = 'Document.pdf';
            cv.PathOnClient = title + '.pdf';
            insert cv;

            for (ContentDocument cd : [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id])
                if (!Test.isRunningTest()) {
                    insert new ContentDocumentLink (ContentDocumentId = cd.Id, LinkedEntityId = oppId, ShareType = 'I');
                }
        }
    }

    /*public static void addDocuments (String envelopeId, TC_DocusignEnvelope docsReq) {
        Http h = new Http ();
        HttpRequest req = new HttpRequest ();
        req.setEndpoint('callout:Docusign' + '/accounts/' + getDefaultAccount().account_id + '/envelopes/' + envelopeId + '/documents');
        req.setMethod('PUT');

        req.setBody(JSON.serialize(docsReq));
        req.setHeader('Content-Type', 'application/json');

        System.debug('addDocuments request - ' + JSON.serialize(docsReq));
        System.debug(req.getBody());

        HttpResponse resp = h.send(req);

        System.debug (resp.getBody());

        if (resp.getStatusCode() == 200) {
            Map <String, Object> urlObj = (Map <String, Object>) JSON.deserializeUntyped(resp.getBody());
        } else {
            Map <String, Object> respObj = (Map <String, Object>) JSON.deserializeUntyped(resp.getBody());
            throw new TC_DocusignServiceException ('Callout error : '
                    + resp.getStatus()
                    + ' - ' + String.valueOf(respObj.get('errorCode'))
                    + ' - ' + String.valueOf(respObj.get('message')));
        }
    }*/

    /*public static void updateToSent (String envelopeId) {
        System.debug('>>>>>>>>envelopeId: ' + envelopeId);
        Http h = new Http ();
        HttpRequest req = new HttpRequest ();
        req.setEndpoint('callout:Docusign' + '/accounts/' + getDefaultAccount().account_id + '/envelopes/' + envelopeId);
        req.setMethod('PUT');

        req.setBody('{"status": "sent"}');
        req.setHeader('Content-Type', 'application/json');

        System.debug('addDocuments request - ' + req);
        System.debug(req.getBody());

        HttpResponse resp = h.send(req);

        System.debug (resp.getBody());

        if (resp.getStatusCode() == 200) {
            Map <String, Object> urlObj = (Map <String, Object>) JSON.deserializeUntyped(resp.getBody());
        } else {
            Map <String, Object> respObj = (Map <String, Object>) JSON.deserializeUntyped(resp.getBody());
            throw new TC_DocusignServiceException ('Callout error : '
                    + resp.getStatus()
                    + ' - ' + String.valueOf(respObj.get('errorCode'))
                    + ' - ' + String.valueOf(respObj.get('message')));
        }
    }*/


    /**
     * @description removes file extension from a file's name to allow proper saving
     *              of documents returned from DocuSign
     *
     * @param fileName
     *
     * @return
     */
    public static String removeFileType (String fileName) {
        if(fileName.containsIgnoreCase('.pdf')) {
            fileName = fileName.remove('.pdf');
        }
        if(fileName.containsIgnoreCase('.docx')) {
            fileName = fileName.remove('.docx');
        }
        return fileName;
    }

    public static String getUserLicense (String userId) {
        System.debug('userId in getUserLicense method: ' + userId);
        List<User> userList = new List<User>();
        User u = new User();
        if(userId == null) {
            userList = [SELECT Profile.UserLicense.Name FROM User WHERE Id = :UserInfo.getUserId()];
            if(!userList.isEmpty()) {
                u = userList[0];
            }
        } else {
            userList = [SELECT Profile.UserLicense.Name FROM User WHERE Id = :userId];
            if(!userList.isEmpty()) {
                u = userList[0];
            }
        }
        return u.Profile.UserLicense.Name;
    }

    public class TC_DocusignServiceException extends Exception {}

}