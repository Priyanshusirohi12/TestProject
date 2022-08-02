/**
 * Created by szheng on 2/18/20.
 */

public without sharing class TC_OnlineApplicationSubmitCtrl {

    private static Map<String, Map<String, Object>> relatedRecordFieldMapping;

    public static Lead createLead(TC_OnlineApplicationCtrl wrapper) {
        Lead lead;
        try {
            lead = new Lead(Id = (String.isEmpty(wrapper.leadId) ? null : wrapper.leadId));
            relatedRecordFieldMapping = createRelatedRecordFieldMapping();
            mapLeadSectionWrapper(lead, wrapper);
            mapGuarantorSectionWrapperList(lead, wrapper);
            mapEquipmentSectionWrapperList(lead, wrapper);
            mapVendorInformation(lead, wrapper);
            System.debug('TC_OnlineApplicationSubmitCtrl upsert lead: ' + lead);
            upsert lead;
            wrapper.leadId = lead.Id;
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException(e.getMessage());
        }
        return lead;
    }

    private static Map<String, Map<String, Object>> createRelatedRecordFieldMapping() {

        Map <String, Schema.SObjectType> allSObjects = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectSchema = allSObjects.get('Lead');
        Schema.DescribeSObjectResult d = sObjectSchema.getDescribe();
        Map<String, Schema.SObjectField> fldObjMap = d.fields.getMap();

        Map<String, Map<String, Object>> relatedRecordFieldMapping = new Map<String, Map<String, Object>>{
                'guarantor2' => new Map<String, Object>()
                , 'guarantor3' => new Map<String, Object>()
                , 'guarantor4' => new Map<String, Object>()
                , 'equipment1' => new Map<String, Object>()
                , 'equipment2' => new Map<String, Object>()
                , 'equipment3' => new Map<String, Object>()
                , 'equipment4' => new Map<String, Object>()
        };

        // Hard-coding fields that could not be dynamically identified as related to Guarantor/Equipment. I thought all of them
        // could be; when am I going to learn that I need to confirm and not just "think" so.
        Set<String> relatedRecordGuarantorField = new Set<String>();
        for (String guarantorField : new Set<String>{'First_Name_2__c', 'Last_Name_2__c', 'Title_2__c', 'Date_of_Birth_2__c', 'Email_2__c', 'Mobile_2__c'
            , 'Ownership_Percent_2__c', 'SSN_2__c'}) {
            relatedRecordGuarantorField.addAll(new Set<String>{guarantorField, guarantorField.replace('2', '3'), guarantorField.replace('2', '4')});
        }

        Set<String> relatedRecordEquipmentField = new Set<String>();
        for (String equipmentField : new Set<String>{'Condition_1__c', 'Serial_Number__c', 'Model__c', 'Vendor__c', 'Vendor_Information_1__c'}) {
            Boolean contains1 = equipmentField.contains('1');
            relatedRecordEquipmentField.addAll(new Set<String>{equipmentField
                    , contains1 ? equipmentField.replace('1', '2') : equipmentField.replace('__c', '_2__c')
                    , contains1 ? equipmentField.replace('1', '3') : equipmentField.replace('__c', '_3__c')});
        }

        for (Schema.SObjectField s : fldObjMap.values()) {
            // Check that sure we are not mapping/setting formula field values
            if (!s.getDescribe().isCalculated()) {
                String fieldName = s.getDescribe().getName();
                Object fieldDefault = s.getDescribe().getDefaultValue();
                if (fieldName.contains('Guarantor') || fieldName.contains('Contact') || relatedRecordGuarantorField.contains(fieldName)) {
                    if (fieldName.contains('2')) relatedRecordFieldMapping.get('guarantor2').put(fieldName, fieldDefault);
                    else if (fieldName.contains('3')) relatedRecordFieldMapping.get('guarantor3').put(fieldName, fieldDefault);
                    else if (fieldName.contains('4')) relatedRecordFieldMapping.get('guarantor4').put(fieldName, fieldDefault);
                } else if (fieldName.contains('Equipment') || relatedRecordEquipmentField.contains(fieldName)) {
                    if (fieldName.contains('2')) relatedRecordFieldMapping.get('equipment2').put(fieldName, fieldDefault);
                    else if (fieldName.contains('3')) relatedRecordFieldMapping.get('equipment3').put(fieldName, fieldDefault);
                    else if (fieldName.contains('4')) relatedRecordFieldMapping.get('equipment4').put(fieldName, fieldDefault);
                    else relatedRecordFieldMapping.get('equipment1').put(fieldName, fieldDefault);
                }
            }
        }

        return relatedRecordFieldMapping;

    }

    private static void mapLeadSectionWrapper(Lead lead, TC_OnlineApplicationCtrl wrapper) {

        List<TC_OnlineApplicationCtrl.SectionWrapper> sectionWrapperList = new List<TC_OnlineApplicationCtrl.SectionWrapper>{
                wrapper.businessSectionWrapper, wrapper.primaryContactSectionWrapper, wrapper.primaryContactGuarSectionWrapper
        };

        for (Integer i = 0; i < sectionWrapperList.size(); i++) {
            TC_OnlineApplicationCtrl.SectionWrapper sectionWrapper = sectionWrapperList[i];
            for (String sectionHeader : sectionWrapper.sectionFields.keySet()) {
                for (AuraFieldDescription afd : sectionWrapper.sectionFields.get(sectionHeader)) {
                    lead.put(afd.fieldName, sectionWrapper.sObjectRecord.get(afd.fieldName));
                }
            }
            // Credit Authorization checkbox saved on sObject in businessSectionWrapper
            if (i == 0) {
                lead.put('Authorized_Credit_Check__c', sectionWrapper.sObjectRecord.get('Authorized_Credit_Check__c'));
            }
            // "Guarantor?" checkbox saved on sObject in primaryContactSectionWrapper
            if (i == 1) {
                lead.put('Personal_Guarantor__c', sectionWrapper.sObjectRecord.get('Personal_Guarantor__c'));
            }
            // primaryContactSectionWrapper does not have an addressBoolean option (controlled in primaryContactGuarSectionWrapper)
            if (sectionWrapper.addressBoolean) {
                String addressMappingMapKey = i == 0 ? 'business' : 'primaryContactGuar';
                for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get(addressMappingMapKey)) {
                    lead.put(addressObject.sectionAddressField, sectionWrapper.sObjectRecord.get(addressObject.standardAddressField));
                }
            }
        }

    }

    private static void mapGuarantorSectionWrapperList(Lead lead, TC_OnlineApplicationCtrl wrapper) {
        String personalGuarantorField = 'Personal_Guarantor_2__c';
        Integer guarantorNumber = 2;
        for (Integer i = 0; i < 3; i++) {
            if (wrapper.guarantorSectionWrapperList.size() > i) {
                TC_OnlineApplicationCtrl.SectionWrapper sectionWrapper = wrapper.guarantorSectionWrapperList[i];
                // To be safe, null-ing existing guarantor if it was deleted through the Online Application
                if (!sectionWrapper.existBoolean && wrapper.leadId != null) {
                    Map<String, Object> guarantorFieldMap = relatedRecordFieldMapping.get('guarantor' + String.valueOf(guarantorNumber));
                    for (String fieldName : guarantorFieldMap.keySet()) {
                        lead.put(fieldName, guarantorFieldMap.get(fieldName));
                    }
                }
                // For each guarantor added through online application, map back to original Lead record with relatedRecordFieldMapping & addressMappingMap
                for (String fieldName : relatedRecordFieldMapping.get('guarantor' + String.valueOf(guarantorNumber)).keySet()) {
                    String fieldSetFieldName = guarantorNumber != 2 ? fieldName.replace(String.valueOf(guarantorNumber), '2') : fieldName;
                    lead.put(fieldName, sectionWrapper.sObjectRecord.get(fieldSetFieldName));
                }
                for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get('guarantor')) {
                    lead.put(addressObject.sectionAddressField.replace('2', String.valueOf(guarantorNumber))
                            , sectionWrapper.sObjectRecord.get(addressObject.standardAddressField));
                }
                // Original version automatically sets checkbox for any guarantor submissions through Online Application
                lead.put(personalGuarantorField.replace('2', String.valueOf(guarantorNumber)), true);
            } else {
                // Null existing guarantors if Online Application used existing leadId
                if (wrapper.leadId != null) {
                    Map<String, Object> guarantorFieldMap = relatedRecordFieldMapping.get('guarantor' + String.valueOf(guarantorNumber));
                    for (String fieldName : guarantorFieldMap.keySet()) {
                        lead.put(fieldName, guarantorFieldMap.get(fieldName));
                    }
                }
            }
            guarantorNumber++;
        }

    }

    private static void mapEquipmentSectionWrapperList(Lead lead, TC_OnlineApplicationCtrl wrapper) {

        Integer equipmentNumber = 1;
        Set<String> equipment1KeySet = relatedRecordFieldMapping.get('equipment1').keySet();
        for (Integer i = 0; i < 3; i++) {
            if (wrapper.equipmentSectionWrapperList.size() > i) {
                TC_OnlineApplicationCtrl.SectionWrapper sectionWrapper = wrapper.equipmentSectionWrapperList[i];
                // To be safe, null-ing existing equipment if it was deleted through Online Application
                if (!sectionWrapper.existBoolean && wrapper.leadId != null) {
                    Map<String, Object> equipmentFieldMap = relatedRecordFieldMapping.get('equipment' + String.valueOf(equipmentNumber));
                    for (String fieldName : equipmentFieldMap.keySet()) {
                        lead.put(fieldName, equipmentFieldMap.get(fieldName));
                    }
                }
                // For each equipment added through online application, map back to original Lead record
                for (String fieldName : relatedRecordFieldMapping.get('equipment' + String.valueOf(equipmentNumber)).keySet()) {
                    String fieldSetFieldName = equipmentNumber != 1 ?
                            (equipment1KeySet.contains(fieldName.replace(String.valueOf(equipmentNumber), '1')) ? fieldName.replace(String.valueOf(equipmentNumber), '1') :
                                    fieldName.replace('_' + String.valueOf(equipmentNumber), '')
                            ) :
                            fieldName;
                    lead.put(fieldName, sectionWrapper.sObjectRecord.get(fieldSetFieldName));
                }
                for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get('equipment')) {
                    lead.put(addressObject.sectionAddressField.replace('1', String.valueOf(equipmentNumber))
                            , sectionWrapper.sObjectRecord.get(addressObject.standardAddressField));
                }
            }  else {
                // Null existing guarantors if Online Application used existing leadId
                if (wrapper.leadId != null) {
                    Map<String, Object> guarantorFieldMap = relatedRecordFieldMapping.get('equipment' + String.valueOf(equipmentNumber));
                    for (String fieldName : guarantorFieldMap.keySet()) {
                        lead.put(fieldName, guarantorFieldMap.get(fieldName));
                    }
                }
            }
            equipmentNumber++;
        }

    }

    private static void mapVendorInformation(Lead lead, TC_OnlineApplicationCtrl wrapper) {

        if (!String.isBlank(wrapper.vendorId)) {
            List<Account> vendorList = new List<Account>([SELECT Id, Sales_Rep2__c FROM Account WHERE Id =: wrapper.vendorId]);
            if (!vendorList.isEmpty()) {
                lead.Vendor_Sales_Rep__c = vendorList[0].Sales_Rep2__c;
                lead.Submitted_by_Vendor__c = wrapper.vendorId;
            }
        }

    }

    public static void attachGuestFileUploads(TC_OnlineApplicationCtrl wrapper) {

        List <Guest_File_Upload__e> fileEvents = new List <Guest_File_Upload__e> ();
        for (ContentDocument contentDocument : wrapper.filesList) {
            fileEvents.add(new Guest_File_Upload__e (
                    Action__c = 'Update',
                    Document_Id__c = contentDocument.Id,
                    Parent_Record_Id__c = wrapper.leadId

            ));
        }
        List<Database.SaveResult> results = EventBus.publish(fileEvents);

    }

    private static ContentVersion generateOnlineApplicationPDF(TC_OnlineApplicationCtrl wrapper) {

        PageReference p = Page.TC_OnlineApplicationPDF;
        p.getParameters().put('leadId', wrapper.leadId);
        p.getParameters().put('partnerCode', wrapper.partnerCode);
        p.getParameters().put('vendorId', (wrapper.vendorId == null) ? '' : wrapper.vendorId);

        List<Id> cdIdList = new List<Id>();
        for (ContentDocument cd : wrapper.filesList) {
            cdIdList.add(cd.Id);
        }
        p.getParameters().put('cdList', String.join(cdIdList, ','));

        Blob pdfPage = Test.isRunningTest() ? Blob.valueOf('test') : p.getContent();

        List<Lead> leads = new List<Lead>([SELECT Company FROM Lead WHERE Id =: wrapper.leadId]);

        // Because Public Guest users cannot DML ContentDocumentLinks, use the TC_ContentVersionTrigger to link the
        // generated PDF to the just-upserted Lead. References custom field Linked_Entity_Id__c on Content Version.
        ContentVersion cv = new ContentVersion(PathOnClient = leads[0].Company + '-Online-Application.pdf'
                , Title = leads[0].Company + ' Online Application', Linked_Entity_Id__c = wrapper.leadId, VersionData = pdfPage);
        
        insert cv;
        System.debug('<<< '+cv.Id+ ' '+wrapper.leadId);
        Online_Application_Add_PDF__e filePDF = new Online_Application_Add_PDF__e(Action__c = 'Update', Document_Id__c = cv.Id, Parent_Record_Id__c = wrapper.leadId);
        Database.SaveResult results = EventBus.publish(filePDF);
        System.debug('<<< results: '+results);

        return cv;

    }

    public static String submitFollowUp(TC_OnlineApplicationCtrl wrapper) {

        try {

            ContentVersion cv = generateOnlineApplicationPDF(wrapper);

            List<TC_Online_Application_Setting__mdt> mdt = new List<TC_Online_Application_Setting__mdt>([
                    SELECT Id, Send_Email_to_Lead__c, Send_Email_to_Lead_Template__c
                    FROM TC_Online_Application_Setting__mdt
                    WHERE Label =: wrapper.partnerCode LIMIT 1]);

            List<Lead> leadList = new List<Lead>([SELECT Id, Email FROM Lead WHERE Id =: wrapper.leadId]);
            String leadPrimaryContactEmail = leadList != null ? leadList[0].Email : null;

            if (!mdt.isEmpty() && mdt[0].Send_Email_to_Lead__c && leadPrimaryContactEmail != null) {

                List <EmailTemplate> templates = new List<EmailTemplate>([
                        SELECT Id
                        FROM EmailTemplate
                        WHERE Name = :mdt[0].Send_Email_to_Lead_Template__c LIMIT 1]);

                if (templates.isEmpty()) {
                    return 'Invalid email template in Online Application Settings configuration; follow-up email cannot be sent. Please contact support.';
                }

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(wrapper.leadId);
                mail.setTemplateId(templates[0].Id);
                mail.setToAddresses (new List<String>{leadPrimaryContactEmail});
                mail.saveAsActivity = false;
                mail.setEntityAttachments(new List<Id>{cv.Id});

                Messaging.SendEmailResult[] results = new List<Messaging.SendEmailResult>();
                if (!Test.isRunningTest()) results = Messaging.sendEmail(new Messaging.Email[] {mail});

                if (!Test.isRunningTest() && !results[0].success) {
                    throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException('Follow-up email failed to send: ' + results[0].errors[0].message);
                }

            }
            return null;

        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException(e.getMessage());
        }

    }

}