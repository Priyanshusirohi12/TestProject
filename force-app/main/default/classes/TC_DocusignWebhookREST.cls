/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-20.
 * Description: 
 */

@RestResource(UrlMapping='/docusignWebhook')
global without sharing class TC_DocusignWebhookREST {

    /**
     * @description receives request from DocuSign once an envelope sent through the API integration is completed.
     *              After verifying the status of the envelope it queries the Docusign Envelope record that was
     *              created on submission in order to pass the opportunity Id, DocuSign account Id and community
     *              user Id into the getDocumentInfo() method.
     */
    @HttpPost
    global static void  doPost () {

        RestRequest req = RestContext.request;
        System.debug('TC_DocusignWebhookREST body: ' + req.requestBody.toString());

        Dom.Document doc = new Dom.Document();
        doc.load(req.requestBody.toString());
        Dom.XMLNode docuSignEnvelopeInformation = doc.getRootElement();
        Dom.XMLNode envelopeStatus = docuSignEnvelopeInformation.getChildElement('EnvelopeStatus', docuSignEnvelopeInformation.getNameSpace());
        String envelopeID = envelopeStatus.getChildElement('EnvelopeID', docuSignEnvelopeInformation.getNameSpace()).getText();
        String subject = envelopeStatus.getChildElement('Subject', docuSignEnvelopeInformation.getNameSpace()).getText();
        String status = envelopeStatus.getChildElement('Status', docuSignEnvelopeInformation.getNameSpace()).getText();

        System.debug('envelopeID: ' + envelopeID);
        System.debug('subject: ' + subject);
        System.debug('status: ' + status);


        if(status == 'Completed') {
            try{
                List<TC_Docusign_Envelope__c> docuEnv = new List<TC_Docusign_Envelope__c>([SELECT Id, Name, Envelope_Id__c, Opportunity__c, Account_Id__c, User_Id__c FROM TC_Docusign_Envelope__c WHERE Envelope_Id__c = :envelopeID]);
                String oppId;
                String accId;
                String userId;
                if(!docuEnv.isEmpty()){
                    oppId = docuEnv[0].Opportunity__c;
                    accId = docuEnv[0].Account_Id__c;
                    userId = docuEnv[0].User_Id__c;
                }


                //TC_DocusignService.saveDocuments(envelopeID, oppId, accId);
                TC_DocusignService.getDocumentInfo(envelopeID,oppId,accId,userId);
                if(!docuEnv.isEmpty()){
                    delete docuEnv;
                }

                System.debug(Docusign_Settings__c.getOrgDefaults());

                if(!TC_DocusignService.getUserLicense(userId).contains('Community') && Docusign_Settings__c.getOrgDefaults().Use_Stage_Updates__c) {
                    List<Opportunity> oppList = new List<Opportunity>();
                    oppList = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId];
                    if(!oppList.isEmpty()) {
                        Opportunity opp = oppList[0];
                        System.debug('docs in sett: ' + Docusign_Settings__c.getOrgDefaults().Docs_In_Stage__c);
                        opp.StageName = Docusign_Settings__c.getOrgDefaults().Docs_In_Stage__c;
                        System.debug('opp.StageName: ' + opp.StageName);
                        try{
                            update opp;
                        }catch(Exception e) {
                            throw new DocusignWebhookRESTException('There was an issue updating the stage. Please check the Docusign Settings.' + e.getMessage() + ': ' + e.getStackTraceString());
                        }
                    }
                }
            } catch (Exception e) {
                throw new DocusignWebhookRESTException('There was an issue saving the signed document: ' + e.getMessage());
            }

        }
    }

    public class DocusignWebhookRESTException extends Exception {}

}