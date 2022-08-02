/**
 * Author: sfdc, Tamarack Consulting, Inc.
 * Date: 2019-08-16.
 * Description:
 */

public without sharing class TC_DocusignEnvelope {

    public String status;
    public String emailBlurb;
    public String emailSubject;
    public String transactionId;
    public String envelopeId;
    public String uri;
    public String statusDateTime;
    public String docusignIframeUrl;
//    public Boolean anchorIgnoreIfNotPresent;
    public List <TemplateRole> templateRoles;
    public EventNotification eventNotification;
    public List <Document> documents;
    public List <CompositeTemplate> compositeTemplates;
    public List <EnvelopeDocument> envelopeDocuments;

    public class TemplateRole {
        public String email;
        public String name;
        public String roleName;
        public String clientUserId;
        public Boolean anchorIgnoreIfNotPresent;
        public Tab tabs = new Tab ();

        /*public void addTab (String anchor, Object value) {
            if (value != null) {
                TextTab tTab = new TextTab ();
                tTab.tabLabel = anchor;
                tTab.value = String.valueOf(value);

                //Checking if a checkbox value, if so replace true with an 'x', dont create a tab for false

                if (tTab.value == 'true') {
                    tTab.value = 'x';
                    tabs.textTabs.add (tTab);
                } else if (tTab.value != 'false') {
                    tabs.textTabs.add (tTab);
                }

            }

        }*/
    }

    public class TextTab {
        public String value;
        public String tabLabel;
        public Boolean anchorIgnoreIfNotPresent = true;
    }

    public class Tab {
        public List <TextTab> textTabs;
        public Tab () {
            textTabs = new List <TextTab> ();
        }
    }

    public class Document {
        public String documentId;
        public String name;
        public String documentBase64;
        public String fileExtension;
        public HTMLDefinition htmlDefinition;
    }

    public class HTMLDefinition {
        public String source;
        public String displayPageNumber;
    }

    public class EventNotification {
        public List<EnvelopeEvent> envelopeEvents;
        public String url;
        public String includeDocuments;
        public String loggingEnabled;
        public String requireAcknowledgement;

    }

    public class EnvelopeEvent {
        public String envelopeEventStatusCode;
    }

    public class CompositeTemplate {
        List<ServerTemplate> serverTemplates;
        List<InlineTemplate> inlineTemplates;
    }

    public class ServerTemplate {
        public String sequence;
        public String templateId;
    }

    public class InlineTemplate {
        public String sequence;
        public Recipient recipients;
    }

    public class Recipient {
        public List<Signer> signers;
    }

    public class RecipientAttachment {
        //public String attachmentId;
        public String attachmentType = '.htm';
        public String data;
    }

    public class EnvelopeDocument {
        public String documentId;
        public String name;
    }

    public class Signer {
        public String email;
        public String name;
        public String roleName;
        public String recipientId;
        public String routingOrder;
        public List<RecipientAttachment> recipientAttachments;
        public Tab tabs = new Tab();
        public void addTab (String anchor, Object value) {
            if (value != null) {
                TextTab tTab = new TextTab ();
                tTab.tabLabel = anchor;
                tTab.value = String.valueOf(value);

                //Checking if a checkbox value, if so replace true with an 'x', dont create a tab for false
                if (tTab.value == 'true') {
                    tTab.value = 'x';
                    tabs.textTabs.add (tTab);
                } else if (tTab.value != 'false') {
                    tabs.textTabs.add (tTab);
                }

            }

        }
    }

    public TC_DocusignEnvelope () {
        templateRoles = new List <TemplateRole> ();

    }

    /**
     * @description 
     *
     * @param acc
     * @param opp
     * @param eqList
     * @param relList
     * @param emailSubject
     * @param emailBlurb
     * @param templateIds
     *
     * @return
     */
    public static TC_DocusignEnvelope createEnvelopeForRequest (Account acc, Opportunity opp, List<Equipment__c> eqList, List<Fee__c> feeList, List<Relationship__c> relList, String emailSubject, String emailBlurb, List<String> templateIds, List<String> counterSignerInfo) {
        TC_DocusignEnvelope env = new TC_DocusignEnvelope();
        //env.documentId = opp.Id;
        env.status = 'sent';
        env.emailBlurb = String.isEmpty(emailBlurb) ? 'Please sign.' : emailBlurb;
        if(TC_DocusignService.getUserLicense(null).contains('Community')) {
            List<User> userList = new List<User>();
            userList = [SELECT Id, Partner_Account_Id__c FROM User WHERE Id = :UserInfo.getUserId()];
            String partnerId = userList[0].Partner_Account_Id__c;
            List<Account> accList = new List<Account>();
            accList = [SELECT Name FROM Account WHERE Id = :partnerId];
            env.emailSubject = String.isEmpty(emailSubject) ? accList[0].Name + ' requires your signature on a document.' : emailSubject;
        } else {
            List<Account> accList = [SELECT Id, Name FROM Account WHERE Id = :Origination_Setting__c.getOrgDefaults().Own_Company_Account_Id__c];
            if(!accList.isEmpty()){
                env.emailSubject = String.isEmpty(emailSubject) ? accList[0].Name + ' requires your signature on a document.' : emailSubject;
            } else {
                env.emailSubject = String.isEmpty(emailSubject) ? 'Required signature on a document.' : emailSubject;
            }
        }



        //env.transactionId = opp.Id;

        /*List<FieldSetMember> eqFieldSet = Schema.SOBjectType.Equipment__c.fieldSets.getMap().get('Docusign_Table_Fields').getFields();
        List<String> eqFieldAPIs = new List<String>();
        for(FieldSetMember fsm : eqFieldSet) {
            eqFieldAPIs.add(eqFieldSet.getFieldPath())
        }
        Map<Id,Map> equipmentMapMap = new Map<Id,Map>();
        Map<String,String> equipmentFieldsMap = new Map<String,String>();*/
        /*String htmlString = '<!DOCTYPE html><html><body><h1>My First Heading</h1><p>My first paragraph.</p></body></html>';
        Blob htmlBlob = Blob.valueOf(htmlString);
        String encodedHtml = EncodingUtil.base64Encode(htmlBlob);*/
        /*RecipientAttachment recAttachment = new RecipientAttachment();
        recAttachment.data = encodedHtml;*/

        //PDF file 0691D000000RJBRQA4      HTML file 0691D000000RIZSQA4
        /*Blob versData = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = '0691D000000RIZSQA4'][0].VersionData;
        System.debug('>>>>>versData: ' + versData);
        String encodedFile = EncodingUtil.base64Encode(versData);
        System.debug('>>>>>>Encoded' + encodedFile);
        HTMLDefinition htmlTable = new HTMLDefinition();
        htmlTable.source = '<!DOCTYPE html><html><body><h1>My First Heading</h1><p>My first paragraph.</p></body></html>';
        htmlTable.displayPageNumber = '2';

        Document doc = new Document();
        doc.name = 'Test';
        doc.htmlDefinition = htmlTable;
        //doc.documentBase64 = encodedHtml;
        //doc.fileExtension = 'html';
        doc.documentId = '123456789';
        env.documents = new List<Document>{doc};*/

        EnvelopeEvent event = new EnvelopeEvent();
        event.envelopeEventStatusCode = 'completed';

        String baseUrl = Docusign_Settings__c.getOrgDefaults().Webhook_Url__c;
        System.debug('BaseUrl: ' + baseUrl);

        EventNotification eventNotif = new EventNotification();
        eventNotif.url = baseUrl + '/services/apexrest/docusignWebhook';
        System.debug('eventNotif url = ' + eventNotif.url);
        eventNotif.requireAcknowledgement = 'true';
        eventNotif.includeDocuments = 'true';
        eventNotif.loggingEnabled = 'true';
        eventNotif.envelopeEvents = new List<EnvelopeEvent>{event};
        env.eventNotification = eventNotif;

        List<CompositeTemplate> compList = new List<CompositeTemplate>();
        List<Signer> envSigners = new List<Signer>();

        Integer numField = 0;
        Signer signerFields = new Signer();
        for(String s : getFieldAPINames('Opportunity')) {
            signerFields.addTab('opportunity.' + s,opp.get(s));
            numField++;
        }

        String accName = null;
        Integer accCount = 0;
        for(String s : getFieldAPINames('Account')) {
            signerFields.addTab('account.' + s, acc.get(s));
            accCount++;
            /*if(s == 'Counter_Signer_for_Docusign__c') {
                counterSigner = acc.get(s);
            }
            if(s == 'Name') {

            }*/

        }

        Integer eqCount = 1;
        for(Equipment__c eq : eqList) {
            for(String s : getFieldAPINames('Equipment__c')) {
                signerFields.addTab('equipment' + eqCount + '.' + s, eq.get(s));
                System.debug('equipment' + eqCount + '.' + s);
            }
            eqCount++;
        }

        Integer feeCount = 1;
        for(Fee__c fee : feeList) {
            for(String s : getFieldAPINames('Fee__c')) {
                signerFields.addTab('fee' + feeCount + '.' + s, fee.get(s));
                System.debug('fee' + feeCount + '.' + s);
            }
            feeCount++;
        }


        Integer relCount = 1;
        for(Relationship__c rel : relList) {
            Signer sign = new Signer();
            sign.name = rel.Contact_Name__c;
            sign.email = rel.Contact_Email__c;
            sign.roleName = 'Signer' + String.valueOf(relCount);
            sign.recipientId = String.valueOf(relCount);
            sign.routingOrder = String.valueOf(relCount);
            sign.tabs.textTabs.addAll(signerFields.tabs.textTabs);
            //sign.recipientAttachments = new List<RecipientAttachment>{recAttachment};

            for(String s : getFieldAPINames('Relationship__c')) {
                sign.addTab('relationship' + relCount + '.' + s, rel.get(s));
            }

            System.debug('Number of Opportunity Fields: ' + numField);
            envSigners.add(sign);
            relCount++;
        }
        Signer cSigner = new Signer();
        cSigner.name = counterSignerInfo[0];
        cSigner.email = counterSignerInfo[1];
        cSigner.roleName = 'CounterSigner';
        cSigner.recipientId = String.valueOf(relCount);
        cSigner.routingOrder = String.valueOf(relCount);
        cSigner.tabs.textTabs.addAll(signerFields.tabs.textTabs);
        envSigners.add(cSigner);





        Recipient rec = new Recipient();
        rec.signers = envSigners;

        if(templateIds != null) {
            for(Integer i = 0; i < templateIds.size(); i++) {

                ServerTemplate st = new ServerTemplate();
                st.templateId = templateIds[i];
                st.sequence = String.valueOf(i);
                List<ServerTemplate> serverTemplates = new List<ServerTemplate>{st};

                InlineTemplate it = new InlineTemplate();
                it.sequence = String.valueOf(i);
                it.recipients = rec;
                List<InlineTemplate> inlineTemplates = new List<InlineTemplate>{it};

                CompositeTemplate composite = new CompositeTemplate();

                if(composite.serverTemplates == null) {
                    composite.serverTemplates = new List<ServerTemplate>(serverTemplates);
                } else {
                    composite.serverTemplates = serverTemplates;
                }

                if(composite.inlineTemplates == null) {
                    composite.inlineTemplates = new List<InlineTemplate>(inlineTemplates);
                } else {
                    composite.inlineTemplates = inlineTemplates;
                }

                if(compList == null) {
                    compList = new CompositeTemplate[]{composite};
                } else {
                    compList.add(composite);
                }

            }
        }

        env.compositeTemplates = new List<CompositeTemplate>(compList);

        return env;
    }

    /**
     * @description loops through all of the fields on the given object and returns all field
     *              API names for that object
     *
     * @param objName, name of object you want to retrieve field API names for
     *
     * @return fieldNames, list of strings that contains each of the parameter object's
     *                      field API names
     */
    public static List<String> getFieldAPINames(String objName) {

        SObjectType obj = Schema.getGlobalDescribe().get(objName);

        Schema.DescribeSObjectResult sObjDesc = obj.getDescribe();
        List<String> fieldNames = new List<String>();
        for(String field : sObjDesc.fields.getMap().keySet()) {
            if(field != 'ChannelProgramName' && field != 'ChannelProgramLevelName') {
                fieldNames.add(field);
            }
        }

        return fieldNames;
    }

    /*public static TC_DocusignEnvelope createEnvelopeForDocs (List<Equipment__c> eqList, List<Relationship__c> relList) {
        TC_DocusignEnvelope env = new TC_DocusignEnvelope ();


        /*List<FieldSetMember> eqFieldSet = Schema.SOBjectType.Equipment__c.fieldSets.getMap().get('Docusign_Table_Fields').getFields();
        List<String> eqFieldAPIs = new List<String>();
        for(FieldSetMember fsm : eqFieldSet) {
            eqFieldAPIs.add(eqFieldSet.getFieldPath())
        }
        Map<Id,Map> equipmentMapMap = new Map<Id,Map>();
        Map<String,String> equipmentFieldsMap = new Map<String,String>();
        String htmlString = '<!DOCTYPE html><html><body><p>Testing 123...</p></body></html>';
        Blob htmlBlob = Blob.valueOf(htmlString);
        System.debug('>>>>htmlBlob: ' + htmlBlob);
        String encodedHtml = EncodingUtil.base64Encode(htmlBlob);
        System.debug('encodedHtml>>>>> ' + encodedHtml);
        ///*RecipientAttachment recAttachment = new RecipientAttachment();
        //recAttachment.data = encodedHtml;
        Document doc = new Document();
        doc.name = 'Test';
        doc.documentBase64 = encodedHtml;
        doc.fileExtension = 'htm';
        doc.documentId = '123456789';
        env.documents = new List<Document>{doc};

        return env;
    }*/
/*
{
  "status":"sent",
  "emailBlurb":"Test Email Body (Template)",
  "emailSubject": "Test Email Subject (Template)",
  "templateId":"270D920E-C65A-410D-9640-75D2FBEADAC2",
  "templateRoles":[
    {
      "email":"mike.rosey@docusign.com",
      "name":"Mike Rosey",
      "roleName":"Signer 1"
    },
    {
      "email":"mike.rosey@docusign.com",
      "name":"Lara Roseleip",
      "roleName":"Signer 2"
    }
  ]
}


RESP

{
  "envelopeId": "c254d988-f501-42d3-a858-feeb50f361e2",
  "status": "sent",
  "statusDateTime": "2012-03-06T17:22:17.2030000Z",
  "uri": "/envelopes/c254d988-f501-42d3-a858-feeb50f361e2"
}

*/


}