/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-21.
 * Description: 
 */

public without sharing class TC_SendWithDocusignCtrl {

    /**
     * @description Retrieves the proper list of Docusign templates based on the number of related Fee and
     *              Equipment records that are related to the Opportunity.
     *
     * @param oppId
     *
     * @return JSON string containing the retrieved Docusign template object records
     */
    @AuraEnabled
    public static String getTemplates (String oppId) {
        List<Equipment__c> eqList = new List<Equipment__c>();
        eqList = [SELECT Id, Name, Opportunity__c FROM Equipment__c WHERE Opportunity__c = :oppId];
        List<Fee__c> feeList = new List<Fee__c>();
        feeList = [SELECT Id, Name, Related_Opportunity__c FROM Fee__c WHERE Related_Opportunity__c = :oppId];

        String templateJSON;
        TC_DocusignEnvelopeTemplate template = new TC_DocusignEnvelopeTemplate();
        List<TC_DocusignEnvelopeTemplate.EnvelopeTemplate> templates = new List<TC_DocusignEnvelopeTemplate.EnvelopeTemplate>();
        Map<String, String> templateMap = TC_DocusignService.getTemplates(oppId, eqList.size(), feeList.size());

        for(String s : templateMap.keySet()) {
            templates.add(new TC_DocusignEnvelopeTemplate.EnvelopeTemplate(s, templateMap.get(s)));
        }

        template.envelopeTemplates = templates;
        templateJSON = JSON.serialize(template);

        return templateJSON;
    }

    /**
     * @description Retrieves list of related Relationship records where the Signer field is marked as true.
     *
     * @param oppId
     *
     * @return JSON string containing related Relationship object records
     */
    @AuraEnabled
    public static String getSigners (String oppId) {
        String relJSON;
        List<Relationship__c> relList;
        try{
            relList = [SELECT Id, Contact_Name__c, Contact_Email__c FROM Relationship__c WHERE Related_Opportunity__c = :oppId AND Signer__c = TRUE];
        } catch (Exception e) {
            throw new TC_SendWithDocusignException('Had trouble finding signers. Error:' + e.getMessage());
        }

        relJSON = JSON.serialize(relList);

        return relJSON;
    }

    /**
     * @description If the user is in the multi-tenant (community) environment, this method will retrieve the partner Id and the
     *              partner Account record based on that Id. If the user is in the single tenant (normal UI) this method will
     *              retrieve the default counter signer name from the Docusign Settings custom setting.
     *
     * @param oppId
     *
     * @return This returns a list with index 0 containing a JSON string of the parent object, index 1 containing the partner Id and
     *         index 2 containing the default counter signer name.
     */
    @AuraEnabled
    public static List<String> getUserandAccountInformation (String oppId) {
        List<String> userAccInfos = new List<String> ();
        Account partnerAccount = new Account();
        String partnerId = '';
        String counterSignerName = '';

        if(TC_DocusignService.getUserLicense(null).contains('Community')) {
            List<User> userList = new List<User>();
            userList = [SELECT Id, Partner_Account_Id__c FROM User WHERE Id = :UserInfo.getUserId()];
            if(!userList.isEmpty()){
                partnerId = userList[0].Partner_Account_Id__c;
            }

            List<Account> accList = new List<Account>();
            accList = [SELECT Id, Counter_Signer_for_Docusign__c, Counter_Signer_for_Docusign__r.Name, Counter_Signer_for_Docusign__r.Email FROM Account WHERE Id = :partnerId];
            if(!accList.isEmpty()){
                partnerAccount = accList[0];
            }

        }else {
            try{
                User counterSigner = [SELECT Id, Name FROM User WHERE Id = :Docusign_Settings__c.getOrgDefaults().Default_Counter_Signer__c][0];
                counterSignerName = counterSigner.Name;
            } catch (Exception e) {
                throw new TC_SendWithDocusignException('No counter signer found for user Id: ' + Docusign_Settings__c.getOrgDefaults().Default_Counter_Signer__c);
            }

        }

        userAccInfos.add(JSON.serialize(partnerAccount));
        userAccInfos.add(partnerId);
        userAccInfos.add(counterSignerName);

        return userAccInfos;
    }

    /**
     * @description This method gathers the data from the lightning component, processes the information and sends the envelope
     *              out for signature. After the envelope is sent a Docusign Envelope record containing unique information is
     *              attached to the Opportunity so that the Webhook process can locate the correct record when the signed document
     *              is returned. Additionally, if the user is using the single-tenant environment and the Use Stage Updates custom
     *              setting field is marked as true the stage will be updated according to the Docs Out Stage custom setting field.
     *
     * @param oppId
     * @param relJSON JSON string containing relationship object(s)
     * @param subject Subject line string for outbound email
     * @param body Body string for outbound email
     * @param templateIds List of docusign template Id strings
     * @param counterSignerId User Id for final signer on documents
     * @param partnerAccountId
     */
    @AuraEnabled
    public static void send (String oppId, String relJSON, String subject, String body, List<String> templateIds, String counterSignerId, String partnerAccountId) {

        List<Relationship__c> relList = (List<Relationship__c>) JSON.deserialize(relJSON, List<Relationship__c>.class);
        List<Equipment__c> eqList = new List<Equipment__c>();
        String query = TC_DataUtility.createSelectAllQueryString('Equipment__c', 'Opportunity__c = :oppId', null);
        eqList = Database.query(query);
        List<Fee__c> feeList = new List<Fee__c>();
        query = TC_DataUtility.createSelectAllQueryString('Fee__c', 'Related_Opportunity__c = :oppId', null);
        feeList = Database.query(query);
        query = TC_DataUtility.createSelectAllQueryString('Opportunity', 'Id = :oppId', null);
        Opportunity opp = Database.query(query);
        String accId = opp.AccountId;
        query = TC_DataUtility.createSelectAllQueryString('Account', 'Id = :accId', null);
        Account acc = new Account();
        if(accId != null) {
            acc = Database.query(query);
        }

        List<User> userCounterSigners = new List<User>();
        List<String> counterSignerInfo = new List<String>();
        if(TC_DocusignService.getUserLicense(null).contains('Community')) {
            query = TC_DataUtility.createSelectAllQueryString('Account', 'Id = :partnerAccountId', null);
            Account partnerAcc = Database.query(query);
            if(counterSignerId == '' || counterSignerId == null) {
                counterSignerId = partnerAcc.Counter_Signer_for_Docusign__c;
            }
            userCounterSigners = [SELECT Id, Name, Email, ContactId FROM User WHERE Id = :counterSignerId];
        } else {
            if(counterSignerId == '' || counterSignerId == null) {
                userCounterSigners = [SELECT Id, Name, Email FROM User WHERE Id = :Docusign_Settings__c.getOrgDefaults().Default_Counter_Signer__c];
            } else {
                userCounterSigners = [SELECT Id, Name, Email FROM User WHERE Id = :counterSignerId];
            }
        }
        if(!userCounterSigners.isEmpty()) {
            counterSignerInfo.add(userCounterSigners[0].Name);
            counterSignerInfo.add(userCounterSigners[0].Email);
        }

        if(relList != null) {

            TC_DocusignEnvelope env = TC_DocusignEnvelope.createEnvelopeForRequest(acc, opp, eqList, feeList, relList, subject, body, templateIds, counterSignerInfo);

            env = TC_DocusignService.createEnvelopeDraft(env);
            System.debug('>>>>>>> Envelope Id: ' + env.envelopeId);

            String docusignAccId = TC_DocusignService.getDefaultAccount().account_id;
            insert new TC_DocuSign_Envelope__c(Name='',Envelope_Id__c=env.envelopeId, Opportunity__c=opp.Id, Account_Id__c=docusignAccId, User_Id__c = UserInfo.getUserId());

            if(!TC_DocusignService.getUserLicense(null).contains('Community') && Docusign_Settings__c.getOrgDefaults().Use_Stage_Updates__c) {
                opp.StageName = Docusign_Settings__c.getOrgDefaults().Docs_Out_Stage__c;
                try{
                    update opp;
                }catch(Exception e) {
                    throw new TC_SendWithDocusignException('There was an issue updating the stage to: ' + Docusign_Settings__c.getOrgDefaults().Docs_Out_Stage__c + '. Please check the Docusign Settings or Opportunity Validation rules.');
                }
            }
        }
    }

    public class TC_SendWithDocusignException extends Exception  {}

}