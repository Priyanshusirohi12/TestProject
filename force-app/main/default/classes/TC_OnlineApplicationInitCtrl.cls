/**
 * Created by szheng on 2/18/20.
 */

public without sharing class TC_OnlineApplicationInitCtrl {

    private static Lead lead;
    private static Boolean newLeadFlag;
    private static Map<String, List<AuraFieldDescription>> businessSectionFields;
    private static Map<String, List<AuraFieldDescription>> primaryContactSectionFields;
    private static Map<String, List<AuraFieldDescription>> primaryContactGuarSectionFields;
    private static Map<String, List<AuraFieldDescription>> guarantorSectionFields;
    private static Map<String, List<AuraFieldDescription>> equipmentSectionFields;
    private static Application_Program__c applicationProgram;
    private static Map<String, Schema.sObjectField> leadFieldsSchemaMap;
    private static Map<String, List<String>> countryStatesMap;
    private static List<Map<String, String>> countryCodeList;
    private static Map<String, Map<String, Object>> relatedRecordFieldMapping;

    private static final String FIELDS_JSON = '{"Disclosure_Text__c":"Test","Lead_Queue_Name__c":"ABC_Lender_Queue"}';

    public static String getSingleTenantCode() {

        String partnerCode;
        Origination_Setting__c originationSetting = Origination_Setting__c.getOrgDefaults();
        if (originationSetting.Own_Company_Account_Id__c == null) {
            throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException('Own Company Account Id is missing. Please contact support.');
        } else {
            partnerCode = originationSetting.Own_Company_Account_Id__c;
        }
        return partnerCode;

    }

    public static void getApplicationProgram(TC_OnlineApplicationCtrl wrapper) {

        Set<String> accountIdSet = new Set<String>();
        accountIdSet.add(wrapper.partnerCode);
        if (!String.isEmpty(wrapper.vendorId)) {
            accountIdSet.add(wrapper.vendorId);
        }
        
        applicationProgram = null;
        String queryString = TC_DataUtility.createSelectAllQueryString(
                'Application_Program__c', 'Vendor__c IN: accountIdSet AND Active__c = TRUE', null);
        List<Application_Program__c> applicationProgramList = (List<Application_Program__c>) Database.query(queryString);
        for (Application_Program__c ap: applicationProgramList) {
            if (!String.isEmpty(wrapper.vendorId) && ap.Vendor__c == wrapper.vendorId) {
                applicationProgram = ap;
                break;
            } else if (ap.Vendor__c == wrapper.partnerCode || applicationProgram == null) {
                applicationProgram = ap;
            }
        }

        if (applicationProgram == null) throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException('No Vendor Program found for generating Online Application. Please contact support.');

        businessSectionFields = getAuraFieldDescriptionBySection(applicationProgram, 'OnlineApplicationFieldSets__c', 'Lead');
        primaryContactSectionFields = getAuraFieldDescriptionBySection(applicationProgram, 'OnlineApplicationContactFieldSets__c', 'Lead');
        primaryContactGuarSectionFields = getAuraFieldDescriptionBySection(applicationProgram, 'OnlineApplicationContactGuarFieldSets__c', 'Lead');
        guarantorSectionFields = getAuraFieldDescriptionBySection(applicationProgram, 'OnlineApplicationGuarantorsFieldSets__c', 'Lead');
        equipmentSectionFields = getAuraFieldDescriptionBySection(applicationProgram, 'OnlineApplicationEquipmentFieldSets__c', 'Lead');

    }

    /**
     * This function will get the associated field set data based on the vendor program record and the field set/object
     * combination and deliver them via a map of the section names to field set
     *
     * @param appProgram               The vendor program sObject
     * @param vpFieldSetName    The vendor program field set name (field on the object)
     * @param objectName        The object type to obtain the field set from
     *
     * @return                  The map of section to field set descriptions
     */
    private static Map<String, List<AuraFieldDescription>> getAuraFieldDescriptionBySection(Application_Program__c vp, String vpFieldSetName, String objectName) {


        Map<String, List<AuraFieldDescription>> returnMap = new Map<String, List<AuraFieldDescription>>();
        String fieldSetValue = String.valueOf(vp.get(vpFieldSetName));
        Map<String, String> field2LabelOverrideMap = setupField2LabelOverrideMap(vp, vpFieldSetName);

        if (String.isNotBlank(fieldSetValue)) {
            for (String headerAndFS : fieldSetValue.split(';')) {
                String header = headerAndFS.split(':')[0];
                String fsName = headerAndFS.split(':')[1];
                List <AuraFieldDescription> afds = new List <AuraFieldDescription>();
                Integer counter = 0;

                if (Schema.describeSObjects(new List<String> {
                        objectName
                })[0].fieldSets.getMap().get(fsName) != null) {
                    for (FieldSetMember fsm : Schema.describeSObjects(new List<String> {
                            objectName
                    })[0].fieldSets.getMap().get(fsName).getFields()) {
                        AuraFieldDescription afd = new AuraFieldDescription(counter++, fsm.SObjectField.getDescribe(), fsm.SObjectField.getDescribe().getDefaultValue());
                        if (fsm.getRequired()) afd.isRequired = true;
                        //Overriding the field label if applicable
                        if (field2LabelOverrideMap.containsKey(afd.fieldName.toLowerCase())) afd.fieldLabel = field2LabelOverrideMap.get(afd.fieldName.toLowerCase());
                        afds.add(afd);
                    }
                }

                returnMap.put(header, afds);
            }
        }
        return returnMap;

    }

    /**
     * This function will setup field to label overrides mapped by the field name (lower case)
     *
     * @param appProgram        The vendor program sObject
     * @param vpFieldSetName    The vendor program field set name (field on the object)
     *
     * @return                  The map of field name to override label
     */
    private static Map<String, String> setupField2LabelOverrideMap (Application_Program__c applicationProgram, String vpFieldSetName) {

        Map<String, String> returnMap = new Map<String, String>();

        String overrideText = '';
        if (String.isNotBlank(vpFieldSetName)) {
            overrideText = vpFieldSetName.equalsIgnoreCase('OnlineApplicationFieldSets__c') ? (String) applicationProgram.get('OnlineApplicationLabels__c') : overrideText;
            overrideText = vpFieldSetName.equalsIgnoreCase('OnlineApplicationContactFieldSets__c') ? (String) applicationProgram.get('OnlineApplicationContactLabels__c') : overrideText;
            overrideText = vpFieldSetName.equalsIgnoreCase('OnlineApplicationContactGuarFieldSets__c') ? (String) applicationProgram.get('OnlineApplicationContactGuarLabels__c') : overrideText;
            overrideText = vpFieldSetName.equalsIgnoreCase('OnlineApplicationGuarantorsFieldSets__c') ? (String) applicationProgram.get('OnlineApplicationGuarantorsLabels__c') : overrideText;
            overrideText = vpFieldSetName.equalsIgnoreCase('OnlineApplicationEquipmentFieldSets__c') ? (String) applicationProgram.get('OnlineApplicationEquipmentLabels__c') : overrideText;
        }

        if (String.isNotBlank(overrideText)) {
            for (String field2ValPair : overrideText.split(';')) {
                List<String> vals = field2ValPair.split(':');
                if (vals.size() == 2) returnMap.put(vals[0].toLowerCase(), vals[1]);
            }
        }
        return returnMap;

    }

    public static void getAppSettingInformation(TC_OnlineApplicationCtrl wrapper) {

        String partnerCode = wrapper.partnerCode;
        String q = TC_DataUtility.createSelectAllQueryString('TC_Online_Application_Setting__mdt', ' Label =: partnerCode', null);
        List<TC_Online_Application_Setting__mdt> mdtSettingsList = Database.query(q);

        if (mdtSettingsList.isEmpty() && !Test.isRunningTest()) throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException('No Online Application settings found for generating Online Application. Please contact support.');
        TC_Online_Application_Setting__mdt mdtSetting = !Test.isRunningTest() ? mdtSettingsList[0] : (TC_Online_Application_Setting__mdt) JSON.deserialize(FIELDS_JSON, TC_Online_Application_Setting__mdt.class);

        List<Account> accountList = new List<Account>([SELECT Id, Name, Company_Email__c, Phone FROM Account WHERE Id =: wrapper.partnerCode]);
        if (accountList.isEmpty()) throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException('No Partner Account found for generating Online Application. Please contact support.');
        Account partnerAccount = accountList[0];
        String disclosureText = String.isEmpty(mdtSetting.Disclosure_Text__c) ? '' : mdtSetting.Disclosure_Text__c;
        disclosureText = String.isEmpty(partnerAccount.Name) ? disclosureText : disclosureText.replace('{{lender.name}}', partnerAccount.Name);
        disclosureText = String.isEmpty(partnerAccount.Company_Email__c) ? disclosureText : disclosureText.replace('{{lender.email}}', partnerAccount.Company_Email__c);
        disclosureText = String.isEmpty(partnerAccount.Phone) ? disclosureText : disclosureText.replace('{{lender.phone}}', partnerAccount.Phone);
        wrapper.disclosureText = disclosureText;

        List<Group> queueGroupList = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE DeveloperName = :mdtSetting.Lead_Queue_Name__c LIMIT 1]);
        if (queueGroupList.isEmpty()) throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException('Invalid Lead Queue found when generating Online Application. Please contact support.');
        wrapper.queueGroupId = queueGroupList[0].Id;
        
        wrapper.useGoogleAddressApi = mdtSetting.Use_Google_Address_API__c;

    }

    public static void getStateCountryPicklistInformation(TC_OnlineApplicationCtrl wrapper) {

        DescribeFieldResult countryDfr = Contact.MailingCountryCode.getDescribe();
        TC_DependentPicklist dependentPicklist = new TC_DependentPicklist ();
        Map<String, List<String>> fullCountryStatesMap = dependentPicklist.controllingToDependentValues (
                countryDfr.getSObjectField(), Contact.MailingStateCode.getDescribe().getSobjectField());

        countryStatesMap = new Map<String, List<String>>();
        countryCodeList = new List<Map<String, String>>();
        for (PicklistEntry pe : countryDfr.getPicklistValues()) {
            if (pe.isActive() && fullCountryStatesMap.get(pe.getValue()).size() > 0) {
                countryStatesMap.put(pe.getValue(), fullCountryStatesMap.get(pe.getValue()));
                countryCodeList.add(new Map<String, String>{'value' => pe.getValue(), 'label' => pe.getLabel()});
            }
        }

    }

    public static void getLeadInformation(String urlParameters, TC_OnlineApplicationCtrl wrapper) {

        lead = new Lead();
        wrapper.guarantorSectionWrapperList = new List<TC_OnlineApplicationCtrl.SectionWrapper>();
        wrapper.equipmentSectionWrapperList = new List<TC_OnlineApplicationCtrl.SectionWrapper>();

        leadFieldsSchemaMap = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap();
        relatedRecordFieldMapping = createRelatedRecordFieldMapping();

        try {

            newLeadFlag = true;
            if (wrapper.leadId != null && wrapper.leadId != '') {
                String leadId = wrapper.leadId;
                String q = TC_DataUtility.createSelectAllQueryString('Lead', ' Id=:leadId', null);
                List<Lead> leadList = (List<Lead>) Database.query(q);
                if (leadList.isEmpty()) {
                    wrapper.warningMessageList.add('leadId \'' + wrapper.leadId + '\' is invalid. Using new lead.');
                    wrapper.leadId = '';
                } else {
                    lead = leadList[0];
                    newLeadFlag = false;
                }
            }
            if (newLeadFlag && !String.isEmpty(urlParameters)) {
                mapParamstoLead(wrapper, urlParameters);
            }

            mapBusinesstoLead(wrapper);
            mapPrimaryContacttoLead(wrapper);
            mapLeadtoRelatedRecords(wrapper);
            createTemplates(wrapper);

        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException(ex.getMessage());
        }

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

    private static void mapLeadtoRelatedRecords(TC_OnlineApplicationCtrl wrapper) {

        try {
            mapLeadtoGuarantors(wrapper);
            mapLeadtoEquipment(wrapper);
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException(e.getMessage());
        }

    }

    private static void mapLeadtoGuarantors(TC_OnlineApplicationCtrl wrapper) {
        // 1. Retrieve relevant fields from guarantors
        // Add from guarantor relatedRecordMapping and from guarantor address mapping
        Set<String> guarantorFieldSet = new Set<String>();

        for (String guarantorKey : new List<String>{'guarantor2', 'guarantor3', 'guarantor4'}) {
            for (String fieldName : relatedRecordFieldMapping.get(guarantorKey).keySet()) {
                guarantorFieldSet.add(fieldName);
            }
        }

        for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get('guarantor')) {
            guarantorFieldSet.add(addressObject.sectionAddressField);
            for (Integer i = 3; i < 5; i++) {
                guarantorFieldSet.add(addressObject.sectionAddressField.replace('2', String.valueOf(i)));
            }
        }

        // 2. Add guarantor booleans and guarantor leads to guarantorMap
        Map<String, Object> guarantorMap = new Map<String, Object>();
        for (Integer i = 2; i < 5; i++) {
            guarantorMap.put('guarantorBoolean' + String.valueOf(i), false);
            guarantorMap.put('guarantor' + String.valueOf(i), new Lead());
        }

        // 3. Update guarantorMap
        // Create new Lead for each guarantor, set all fields to guarantor2 fields to leverage reusing guarantor field
        // set (only includes guarantor2 fields). If field is an address field, set to main Lead address field.
        Map<String, String> guarantorAddressMap = new Map<String, String>();
        for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get('guarantor')) {
            guarantorAddressMap.put(addressObject.sectionAddressField, addressObject.standardAddressField);
        }
        for (String field : guarantorFieldSet) {
            Object fieldValue = lead.get(field);
            if (fieldValue != null) {
                String guarantorNumber = field.contains('2') ? '2' : (field.contains('3') ? '3' : '4');
                if (leadFieldsSchemaMap.get(field).getDescribe().getDefaultValue() == null) {
                    guarantorMap.put('guarantorBoolean' + guarantorNumber, true);
                }
                Lead guarantorLead = (Lead) guarantorMap.get('guarantor' + guarantorNumber);
                String fieldUpdated = field.replace(guarantorNumber, '2');
                if (guarantorAddressMap.containsKey(fieldUpdated)) {
                    guarantorLead.put(guarantorAddressMap.get(fieldUpdated), fieldValue);
                } else {
                    guarantorLead.put(fieldUpdated, fieldValue);
                }
                guarantorMap.put('guarantor' + guarantorNumber, guarantorLead);
            }
        }

        // 4. Add to wrapper.guarantorSectionWrapperList
        // Must deepClone guarantorSectionFields => in auraFieldSectionDisplay, references guarantorSectionFields,
        // not the sObject. So, must use different guarantorSectionFields for each guarantor.
        for (Integer i = 2; i < 5; i++) {
            if ((Boolean) guarantorMap.get('guarantorBoolean' + String.valueOf(i))) {
                Map<String, List<AuraFieldDescription>> guarantorSectionFieldsClone = guarantorSectionFields.clone();
                TC_OnlineApplicationCtrl.SectionWrapper guarantorSectionWrapper = new TC_OnlineApplicationCtrl.SectionWrapper(guarantorSectionFieldsClone
                        , new List<String>(guarantorSectionFieldsClone.keySet()), (Lead) guarantorMap.get('guarantor' + String.valueOf(i))
                        , applicationProgram.Online_Application_Guarantors_Address__c, countryStatesMap.clone(), countryCodeList.clone(), true
                );
                wrapper.guarantorSectionWrapperList.add(guarantorSectionWrapper);
            }
        }

    }

    private static void mapLeadtoEquipment(TC_OnlineApplicationCtrl wrapper) {
        // Identical process to mapping Guarantor Records, except that equipment records start at equipment1
        // (guarantor records start at guarantor2 because guarantor1 == Primary Contact on Lead)
        // 1. Retrieve relevant fields from equipment field set
        // Add from equipment relatedRecordMapping and from equipment address mapping
        Set<String> equipmentFieldSet = new Set<String>();

        for (String equipmentKey : new List<String>{'equipment1', 'equipment2', 'equipment3'}) {
            for (String fieldName : relatedRecordFieldMapping.get(equipmentKey).keySet()) {
                equipmentFieldSet.add(fieldName);
            }
        }

        for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get('equipment')) {
            equipmentFieldSet.add(addressObject.sectionAddressField);
            for (Integer i = 2; i < 4; i++) {
                equipmentFieldSet.add(addressObject.sectionAddressField.replace('1', String.valueOf(i)));
            }
        }

        // 2. Add equipment booleans and equipment leads to equipmentMap
        Map<String, Object> equipmentMap = new Map<String, Object>();
        for (Integer i = 1; i < 4; i++) {
            equipmentMap.put('equipmentBoolean' + String.valueOf(i), false);
            equipmentMap.put('equipment' + String.valueOf(i), new Lead());
        }

        // 3. Update equipmentMap
        // Create new Lead for each equipment, set all fields to equipment1 fields to leverage reusing equipment field
        // set (only includes equipment1 fields).
        Map<String, String> equipmentAddressMap = new Map<String, String>();
        for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get('equipment')) {
            equipmentAddressMap.put(addressObject.sectionAddressField, addressObject.standardAddressField);
        }
        for (String field : equipmentFieldSet) {
            Object fieldValue = lead.get(field);
            if (fieldValue != null) {
                String equipmentNumber = field.contains('2') ? '2' : (field.contains('3') ? '3' : (field.contains('4') ? '4' : '1'));
                if (leadFieldsSchemaMap.get(field).getDescribe().getDefaultValue() == null) {
                    equipmentMap.put('equipmentBoolean' + equipmentNumber, true);
                }
                Lead equipmentLead = (Lead) equipmentMap.get('equipment' + equipmentNumber);
                String fieldUpdated = leadFieldsSchemaMap.containsKey(field.replace(equipmentNumber, '1')) ? field.replace(equipmentNumber, '1') : field.replaceAll('_2|_3|_4', '');
                if (equipmentAddressMap.containsKey(fieldUpdated)) {
                    equipmentLead.put(equipmentAddressMap.get(fieldUpdated), fieldValue);
                } else {
                    equipmentLead.put(fieldUpdated, fieldValue);
                }
                equipmentLead.put(fieldUpdated, fieldValue);
                equipmentMap.put('equipment' + equipmentNumber, equipmentLead);
            }
        }

        // 4. Add to wrapper.equipmentSectionWrapperList
        // Must deepClone equipmentSectionFields => in auraFieldSectionDisplay, references equipmentSectionFields,
        // not the sObject. So, must use different equipmentSectionFields for each equipment.
        for (Integer i = 1; i < 4; i++) {
            if ((Boolean) equipmentMap.get('equipmentBoolean' + String.valueOf(i))) {
                Map<String, List<AuraFieldDescription>> equipmentSectionFieldsClone = equipmentSectionFields.clone();
                TC_OnlineApplicationCtrl.SectionWrapper equipmentSectionWrapper = new TC_OnlineApplicationCtrl.SectionWrapper(equipmentSectionFieldsClone
                        , new List<String>(equipmentSectionFieldsClone.keySet()), (Lead) equipmentMap.get('equipment' + String.valueOf(i))
                        , applicationProgram.Online_Application_Equipment_Address__c, countryStatesMap.clone(), countryCodeList.clone(), true, false
                );
                wrapper.equipmentSectionWrapperList.add(equipmentSectionWrapper);
            }
        }

    }

    private static void mapParamstoLead(TC_OnlineApplicationCtrl wrapper, String urlParameters) {

        try {
            List<String> invalidFieldsList = new List<String>();
            Map<String, Object> urlParametersMap = (Map<String, Object>) JSON.deserializeUntyped(urlParameters);

            for (String urlParam : urlParametersMap.keySet()) {
                if (!(leadFieldsSchemaMap.keySet().contains(urlParam?.toLowerCase()))) {
                    invalidFieldsList.add(urlParam);
                } else if (urlParam == 'Name') {
                    invalidFieldsList.add('Name');
                    wrapper.warningMessageList.add('Try splitting Name into FirstName & LastName instead.');
                } else if (leadFieldsSchemaMap.get(urlParam).getDescribe().isCalculated()) {
                    wrapper.warningMessageList.add(urlParam + ' is a formula field and cannot be written to.');
                } else {
                    String fieldType = leadFieldsSchemaMap.get(urlParam).getDescribe().getType().Name();
                    String paramValue = EncodingUtil.urlDecode((String)urlParametersMap.get(urlParam), 'UTF-8');
                    if (fieldType == 'String' || fieldType == 'Email' || fieldType == 'Phone' || fieldType == 'Picklist') {
                        lead.put(urlParam, paramValue);
                    } else if (fieldType == 'Integer' || fieldType == 'Decimal' || fieldType =='Currency' || fieldType == 'Double') {
                        try {
                            Decimal castToDecimal = Decimal.valueOf(paramValue);
                            lead.put(urlParam, castToDecimal);
                        } catch (System.TypeException e) {
                            wrapper.warningMessageList.add(paramValue + ' is not a valid value for ' + urlParam);
                        }
                    } else if (fieldType == 'Boolean') {
                        try {
                            Boolean castToBoolean = Boolean.valueOf(paramValue);
                            lead.put(urlParam, castToBoolean);
                        } catch (System.TypeException e) {
                            wrapper.warningMessageList.add(paramValue + ' is not a valid value for ' + urlParam);
                        }
                    } else if (fieldType == 'Date') {
                        try {
                            Date castToDate = Date.valueOf(paramValue);
                            lead.put(urlParam, castToDate);
                        } catch (System.TypeException e) {
                            wrapper.warningMessageList.add(paramValue + ' is not a valid value for ' + urlParam);
                        }
                    } else if (fieldType == 'DateTime') {
                        try {
                            DateTime castToDateTime = DateTime.valueOf(paramValue);
                            lead.put(urlParam, castToDateTime);
                        } catch (System.TypeException e) {
                            wrapper.warningMessageList.add(paramValue + ' is not a valid value for ' + urlParam);
                        }
                    }
                }
            }

            if (!invalidFieldsList.isEmpty()) {
                wrapper.warningMessageList.add('URL parameters [' + String.join(invalidFieldsList, ', ') + '] cannot be defaulted on a Lead.');
            }
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new TC_OnlineApplicationCtrl.TC_OnlineApplicationCtrlException(e.getMessage());
        }

    }

    private static void mapBusinesstoLead(TC_OnlineApplicationCtrl wrapper) {

        System.debug('TC_OnlineApplicationInitCtrl - mapBusinesstoLead: ' + lead);
        wrapper.businessSectionWrapper = new TC_OnlineApplicationCtrl.SectionWrapper(businessSectionFields, new List<String>(businessSectionFields.keySet())
                , lead, applicationProgram.Online_Application_Main_Info_Address__c, countryStatesMap.clone(), countryCodeList.clone()
        );

    }

    private static void mapPrimaryContacttoLead(TC_OnlineApplicationCtrl wrapper) {

        // Similar to guarantors and equipment, map Primary Contact section's lead to its own records. One for the
        // Lead Primary Contact information (primaryContactSectionWrapper), the second for the Lead Primary Contact
        // Guarantor information (primaryContactGuarSectionWrapper). In the Aura Component, primaryContactGuarSection
        // only renders if "Is Guarantor?" checkbox is selected. Set it to default to checked for new leads.

        Lead leadClone = lead.clone();
        leadClone.Personal_Guarantor__c = newLeadFlag ? true : leadClone.Personal_Guarantor__c;
        wrapper.primaryContactSectionWrapper = new TC_OnlineApplicationCtrl.SectionWrapper(primaryContactSectionFields
                , new List<String>(primaryContactSectionFields.keySet()), leadClone, false
                , countryStatesMap.clone(), countryCodeList.clone()
        );

        // Use addressMappingMap to map Primary Contact Guarantor address fields to the generic Lead Address fields.
        Lead primaryContactGuarLead = lead.clone(false, true);
        for (TC_OnlineApplicationCtrl.addressObject addressObject : wrapper.addressMappingMap.get('primaryContactGuar')) {
            Object fieldValue = lead.get(addressObject.sectionAddressField);
            primaryContactGuarLead.put(addressObject.standardAddressField, fieldValue);
        }

        wrapper.primaryContactGuarSectionWrapper = new TC_OnlineApplicationCtrl.SectionWrapper(primaryContactGuarSectionFields
                , new List<String>(primaryContactGuarSectionFields.keySet()), primaryContactGuarLead
                , applicationProgram.Online_Application_Contact_Guar_Address__c
                , countryStatesMap.clone(), countryCodeList.clone()
        );

    }

    private static void createTemplates(TC_OnlineApplicationCtrl wrapper) {

        // Easy addition of guarantors in Aura Component
        Map<String, List<AuraFieldDescription>> guarantorSectionFieldsClone = guarantorSectionFields.clone();
        wrapper.guarantorSectionWrapperTemplate = new TC_OnlineApplicationCtrl.SectionWrapper(guarantorSectionFieldsClone
                , new List<String>(guarantorSectionFieldsClone.keySet()), new Lead(), applicationProgram.Online_Application_Guarantors_Address__c
                , countryStatesMap.clone(), countryCodeList.clone(), false
        );

        // Easy addition of equipment in Aura Component
        Map<String, List<AuraFieldDescription>> equipmentSectionFieldsClone = equipmentSectionFields.clone();
        wrapper.equipmentSectionWrapperTemplate = new TC_OnlineApplicationCtrl.SectionWrapper(equipmentSectionFieldsClone
                , new List<String>(equipmentSectionFieldsClone.keySet()), new Lead(), applicationProgram.Online_Application_Equipment_Address__c
                , countryStatesMap.clone(), countryCodeList.clone(), false, false
        );

    }

    /*public static void getQuoteInformation(TC_OnlineApplicationCtrl wrapper) {

        if (!String.isEmpty(wrapper.leadId)) {

            List<TC_OnlineApplicationCtrl.DataTableColumn> dataTableColumnList = new List<TC_OnlineApplicationCtrl.DataTableColumn>();

            String fieldSet = 'Quote_Details';
            Set<String> fieldSetFields = new Set<String>{'Id'};
            Integer counter = 0;

            if (Schema.describeSObjects(new List<String> {'Quote_Option__c'})[0].fieldSets.getMap().get(fieldSet) != null) {
                for (FieldSetMember fsm : Schema.describeSObjects(new List<String> {'Quote_Option__c'})[0].fieldSets.getMap().get(fieldSet).getFields()) {
                    AuraFieldDescription afd = new AuraFieldDescription(counter++, fsm.SObjectField.getDescribe(), fsm.SObjectField.getDescribe().getDefaultValue());
                    if (fsm.getRequired()) afd.isRequired = true;
                    dataTableColumnList.add(new TC_OnlineApplicationCtrl.DataTableColumn(afd));
                    fieldSetFields.add(fsm.fieldPath);
                }
            }

            String leadId = wrapper.leadId;
            String query = 'SELECT ' + String.join(new List<String>(fieldSetFields), ',') +
                    'FROM Quote_Option__c WHERE Lead__c =: leadId ORDER BY Selected_Quote_Option DESC, CreatedDate DESC';
            List<Quote_Option__c> quoteOptionList = Database.query(query);
            Id selectedQuoteOptionId = (!quoteOptionList.isEmpty()) ? quoteOptionList[0].Id : null;

            wrapper.quoteSectionWrapper = new TC_OnlineApplicationCtrl.QuoteWrapper(dataTableColumnList, quoteOptionList, selectedQuoteOptionId);

        }

    }*/

}