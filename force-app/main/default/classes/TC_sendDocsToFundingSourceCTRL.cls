public class TC_sendDocsToFundingSourceCTRL {

    @AuraEnabled
    public static wizardWrapper setWizardWrapper(Id recordId) {

        try {
            wizardWrapper returnWrapper = new wizardWrapper();
            returnWrapper.opportunity = grabOpp(recordId);
            returnWrapper.fileWrapperList = grabFiles(returnWrapper);
            returnWrapper = grabEmailTemplate(returnWrapper);
            returnWrapper.fsEditBoolean = grabFSOption();
            return returnWrapper;
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }

    }

    public static Opportunity grabOpp(Id recordId) {

        List<Opportunity> opportunities = new List<Opportunity>([
                SELECT Id, Name
                ,(SELECT Id, Funding_Source__r.Funding_Email__c, Funding_Source__r.Name FROM Funding_Sources__r
                WHERE Funding_Source__c != null)
                ,(SELECT Id, Person__c, Business__c FROM Relationships_Opportunity__r
                WHERE Person__c != null OR Business__c != null)
                FROM Opportunity
                WHERE Id = :recordId]);

        return (!opportunities.isEmpty() ? opportunities[0] : null);
    }

    public static List<fileWrapper> grabFiles(wizardWrapper returnWrapper){

        Map<Id, String> linkedEntityIdSet = new Map<Id, String>();

        Set<Id> creditContactIdSet = new Set<Id>();
        Set<Id> pgContactIdSet = new Set<Id>();
        Set<Id> cgAccountIdSet = new Set<Id>();
        for (Relationship__c relationship : returnWrapper.opportunity.Relationships_Opportunity__r) {
            if (relationship.Person__c != null) {
                creditContactIdSet.add(relationship.Person__c);
                pgContactIdSet.add(relationship.Person__c);
            } else if (relationship.Business__c != null) {
                cgAccountIdSet.add(relationship.Business__c);
            }
        }


        for (Id pgId : new List<Id>(pgContactIdSet)) {
            linkedEntityIdSet.put(pgId, 'Personal Guarantor Attachment');
        }
        for (Id cgId : new List<Id>(cgAccountIdSet)) {
            linkedEntityIdSet.put(cgId, 'Corporate Guarantor Attachment');
        }
        linkedEntityIdSet.put(returnWrapper.opportunity.Id, 'Opportunity Attachment');

        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>([
                SELECT ContentDocumentId, ContentDocument.Title, LinkedEntityId
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN :linkedEntityIdSet.keySet()]);

        Map<Id, String> cdSourceMapSet = new Map<Id, String>();
        for (ContentDocumentLink cdl : cdlList) {
            if (cdSourceMapSet.containsKey(cdl.ContentDocumentId)) {
                String appendedDescription = cdSourceMapSet.get(cdl.ContentDocumentId) + ', ' + linkedEntityIdSet.get(cdl.LinkedEntityId);
                cdSourceMapSet.put(cdl.ContentDocumentId, appendedDescription);
            } else {
                cdSourceMapSet.put(cdl.ContentDocumentId, linkedEntityIdSet.get(cdl.LinkedEntityId));
            }
        }

        List<ContentDocument> cdList = new List<ContentDocument>([
                SELECT Id, LatestPublishedVersionId, Title, FileType
                FROM ContentDocument
                WHERE Id IN :cdSourceMapSet.keySet()
        ]);

        List<fileWrapper> fileWrapperList = new List<fileWrapper>();
        for (ContentDocument cd : cdList) {
            fileWrapper fw = new fileWrapper(cd, cdSourceMapSet.get(cd.Id));
            fileWrapperList.add(fw);
        }

        return fileWrapperList;

    }

    public static wizardWrapper grabEmailTemplate(wizardWrapper returnWrapper) {

        try {

            // Query to get relevant client LK EF Lender Account
            Id userId = UserInfo.getUserId();
            List<User> users = new List<User>([
                    SELECT Id, AccountId, Account.Funding_Wizard_Email_Template__c, Account.Funding_Wizard_Edit_Records__c
                    FROM User WHERE Id =: userId]);

            String templateName = 'N/A';
            if (!users.isEmpty()) {
                User currentUser = users[0];
                if (currentUser.AccountId != null) {
                    if (currentUser.Account.Funding_Wizard_Email_Template__c != null) {
                        templateName = users[0].Account.Funding_Wizard_Email_Template__c;
                    }
                } else {
                    Origination_Setting__c originationSetting = Origination_Setting__c.getInstance();
                    templateName = originationSetting.Funding_Wizard_Email_Template__c;
                }

            }

            Map <String, String> returnMap = new Map <String, String> ();
            if (templateName != 'N/A') {
                List <EmailTemplate> templates = new List<EmailTemplate>([SELECT Id FROM EmailTemplate WHERE Name = :templateName LIMIT 1]);

                if (templates.isEmpty()) {
                    returnWrapper.warningMessage = 'Default template ' + '"' + templateName + '" specified on' +
                            ' your LK Partner Account is not a valid email template.';
                    templateName = 'N/A';
                    returnMap.put('htmlBody', '');
                    returnMap.put('subject', '');
                } else {
                    Messaging.SingleEmailMessage res = Messaging.renderStoredEmailTemplate(
                            templates[0].Id, UserInfo.getUserId(), returnWrapper.opportunity.Id);
                    returnMap.put('htmlBody', res.getHtmlBody());
                    returnMap.put('subject', res.getSubject());
                }
            } else {
                returnMap.put('htmlBody', '');
                returnMap.put('subject', '');
            }

            returnWrapper.emailTemplate.templateName = templateName;
            returnWrapper.emailTemplate.subject = returnMap.get('subject');
            returnWrapper.emailTemplate.htmlBody = returnMap.get('htmlBody');
            returnWrapper.emailTemplate.templateValue = 'Default';

            returnWrapper.emailWrapper.subject = returnMap.get('subject');
            returnWrapper.emailWrapper.htmlBody = returnMap.get('htmlBody');

            return returnWrapper;

        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }

    }

    public static Boolean grabFSOption() {

        try {
            // Query to get relevant client LK EF Lender Account
            Id userId = UserInfo.getUserId();
            List<User> users = new List<User>([
                    SELECT Id, AccountId, Account.Funding_Wizard_Edit_Records__c
                    FROM User WHERE Id =: userId]);

            Boolean recordEdit = false;
            if (!users.isEmpty()) {
                User currentUser = users[0];
                if (currentUser.AccountId != null) {
                    recordEdit = users[0].Account.Funding_Wizard_Edit_Records__c;
                } else {
                    Origination_Setting__c originationSetting = Origination_Setting__c.getInstance();
                    recordEdit = originationSetting.Funding_Wizard_Edit_Records__c;
                }
            }

            return recordEdit;
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }

    }

    @AuraEnabled
    public static Account selectLender(Id recordId) {
        Account lender = TC_DataUtility.getAllFieldsOnAccountByRecordId(recordId);
        return lender;
    }

    @AuraEnabled
    public static List<fsWrapper> setFundingSourceRecords(String setFSRecordMapString) {

        try {

            Map<String, String> setFSRecordMap = (Map<String, String>) System.JSON.deserialize(
                    setFSRecordMapString, Map<String, String>.class);

            // Key String = Lender's email
            List<Account> lenderList = (List<Account>) System.JSON.deserialize(
                    setFSRecordMap.get('lenderList'), List<Account>.class);
            Map<String, Account> lenderMap = new Map<String, Account>();
            for (Account lender : lenderList) {
                if (lender.Funding_Email__c != null) {
                    lenderMap.put(lender.Funding_Email__c, lender);
                }
            }

            // New Logic: Only create new Funding Source records for each added Lender email
            List<fsWrapper> fsWrapperList = (List<fsWrapper>) System.JSON.deserialize(
                    setFSRecordMap.get('fsWrapperList'), List<fsWrapper>.class);

            Map<String, fsWrapper> fsWrapperMap = new Map<String, fsWrapper>();
            for (fsWrapper fsWrapper : fsWrapperList) {
                fsWrapperMap.put(fsWrapper.email, fsWrapper);
            }

            Id recordId = setFSRecordMap.get('recordId');

            List<String> selectedEmailList = (List<String>) System.JSON.deserialize(
                    setFSRecordMap.get('selectedEmailList'), List<String>.class);

            for (String selectedEmail : selectedEmailList) {
                if (lenderMap.containsKey(selectedEmail)) {
                    Account lender = lenderMap.get(selectedEmail);
                    Funding_Source__c fs = new Funding_Source__c(Status__c = 'Submitted', Funding_Source__c = lender.Id
                            , Related_Opportunity__c = recordId, Sent_By__c = UserInfo.getUserId());
                    fsWrapper fsWrapper = new fsWrapper(selectedEmail, lender, fs, true);
                    fsWrapperMap.put(selectedEmail, fsWrapper);
                } else {
                    fsWrapperMap.put(selectedEmail, new fsWrapper(selectedEmail, null, null, false));
                }
            }


            // Old Logic: Pull in existing Funding Source Records to edit and create new Funding Source, if desired
            /*Id recordId = setFSRecordMap.get('recordId');
            List<Funding_Source__c> fsList = new List<Funding_Source__c>([
                    SELECT Funding_Source__c, Funding_Source__r.Funding_Email__c, Status__c, Submission_Status__c, Date_Sent__c
                    FROM Funding_Source__c
                    WHERE Related_Opportunity__c =: recordId ORDER BY CreatedDate DESC]);

            // Key Id = Funding Source's Lender/Account
            Map<Id, List<Funding_Source__c>> fsMap = new Map<Id, List<Funding_Source__c>>();
            for (Funding_Source__c fs : fsList) {
                if (!fsMap.containsKey(fs.Funding_Source__c)) {
                    fsMap.put(fs.Funding_Source__c, new List<Funding_Source__c>{fs});
                } else {
                    fsMap.get(fs.Funding_Source__c).add(fs);
                }
            }

            List<fsWrapper> fsWrapperList = (List<fsWrapper>) System.JSON.deserialize(
                    setFSRecordMap.get('fsWrapperList'), List<fsWrapper>.class);

            Map<String, fsWrapper> fsWrapperMap = new Map<String, fsWrapper>();
            for (fsWrapper fsWrapper : fsWrapperList) {
                fsWrapperMap.put(fsWrapper.email, fsWrapper);
            }

            List<String> selectedEmailList = (List<String>) System.JSON.deserialize(
                    setFSRecordMap.get('selectedEmailList'), List<String>.class);

            for (String selectedEmail : selectedEmailList) {
                if (!fsWrapperMap.containsKey(selectedEmail)) {
                    if (lenderMap.containsKey(selectedEmail)) {
                        Account lender = lenderMap.get(selectedEmail);
                        fsWrapper fsWrapper = (fsMap.containsKey(lender.Id)) ?
                                new fsWrapper(selectedEmail, lender, fsMap.get(lender.Id)) :
                                new fsWrapper(selectedEmail, lender, new List<Funding_Source__c>());
                        fsWrapperMap.put(selectedEmail, fsWrapper);
                    } else {
                        fsWrapperMap.put(selectedEmail, new fsWrapper(selectedEmail, null, new List<Funding_Source__c>()));
                    }
                }
            }*/

            Set<String> selectedEmailStringSet = new Set<String>(selectedEmailList);
            for (String fsWrapperKey : fsWrapperMap.keySet()) {
                if (!selectedEmailStringSet.contains(fsWrapperKey)) {
                    fsWrapperMap.remove(fsWrapperKey);
                }
            }

            List<fsWrapper> newFSWrapperList = new List<fsWrapper>();
            for (fsWrapper fsWrapper : fsWrapperMap.values()) {
                newFSWrapperList.add(fsWrapper);
            }

            return newFSWrapperList;

        } catch (Exception ex) {
            System.debug(ex);
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }

    }

    @AuraEnabled
    public static void sendEmailWithFiles(String sendEmailMapParamsString) {

        try {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            Map<String, String> sendEmailMapParams = (Map<String, String>) System.JSON.deserialize(
                    sendEmailMapParamsString, Map<String, String>.class);

            // Set list of email addresses or object IDs of contacts, leads and users receiving email
            List<String> selectedEmailList = (List<String>) System.JSON.deserialize(
                    sendEmailMapParams.get('selectedEmailListString'), List<String>.class);
            mail.setToAddresses(selectedEmailList);

            // Create items to attach
            List<fileWrapper> fileWrapperList = (List<fileWrapper>) System.JSON.deserialize(
                    sendEmailMapParams.get('fileWrapperListString'), List<fileWrapper>.class);

            Set<Id> cvIds = new Set<Id>();
            for(fileWrapper fw: fileWrapperList) {
                cvIds.add(fw.cd.LatestPublishedVersionId);
            }

            List<ContentVersion> cvList = new List<ContentVersion>([
                    SELECT Title, PathOnClient, FileType, VersionData
                    FROM ContentVersion
                    WHERE Id IN: cvIds]);

            List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();

            for (ContentVersion cv : cvList) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(cv.Title + '.' + cv.FileType);
                efa.setBody(cv.VersionData);
                emailFileAttachments.add(efa);
            }

            mail.setFileAttachments(emailFileAttachments);

            // Set subject and body of email
            emailWrapper emailWrapper = (emailWrapper) System.JSON.deserialize(
                    sendEmailMapParams.get('emailWrapperString'), emailWrapper.class);

            mail.setSubject(emailWrapper.subject);
            mail.setHtmlBody(emailWrapper.htmlBody);

            mail.saveAsActivity = false;

            Messaging.SendEmailResult[] results = new List<Messaging.SendEmailResult>();
            if (!Test.isRunningTest()) results = Messaging.sendEmail(new Messaging.Email[] {mail});

            if (Test.isRunningTest() || results[0].success) {

                List<fsWrapper> fsWrapperList = (List<fsWrapper>) System.JSON.deserialize(
                        sendEmailMapParams.get('fsWrapperListString'), List<fsWrapper>.class);

                List<Funding_Source__c> fsList = new List<Funding_Source__c>();
                for (fsWrapper fsWrapper : fsWrapperList) {
                    if (fsWrapper.newRecordBoolean) {
                        fsWrapper.fs.Date_Sent__c = System.now();
                        fsList.add(fsWrapper.fs);
                    }
                }
                upsert fsList;

            } else {
                throw new TC_sendDocsToFundingSourceCTRLException('The email failed to send: ' + results[0].errors[0].message);
            }

        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }

    }

    public class fileWrapper {

        @AuraEnabled
        public ContentDocument cd;
        @AuraEnabled
        public String fileSource;
        @AuraEnabled
        public Boolean isSelected;

        public fileWrapper(ContentDocument cd, String fileSource) {
            this.cd = cd;
            this.fileSource = fileSource;
            this.isSelected = false;
        }

    }

    public class emailWrapper {

        @AuraEnabled
        public String templateName;
        @AuraEnabled
        public String subject;
        @AuraEnabled
        public String htmlBody;
        @AuraEnabled
        public String customSubject;
        @AuraEnabled
        public String customHtmlBody;
        @AuraEnabled
        public String templateValue;

    }

    public class fsWrapper {

        @AuraEnabled
        public String email;
        @AuraEnabled
        public Account lender;
        @AuraEnabled
        public Funding_Source__c fs;
        @AuraEnabled
        public Boolean newRecordBoolean;

        public fsWrapper(String email, Account lender, Funding_Source__c fs, Boolean newRecordBoolean) {
            this.email = email;
            this.lender = lender;
            this.fs = fs;
            this.newRecordBoolean = newRecordBoolean;
        }

    }

    public class wizardWrapper {

        @AuraEnabled
        public Opportunity opportunity;
        @AuraEnabled
        public String warningMessage;
        @AuraEnabled
        public List<String> filterArray;
        @AuraEnabled
        public List<String> selectedEmailList;
        @AuraEnabled
        public List<Account> lenderList;
        @AuraEnabled
        public emailWrapper emailTemplate;
        @AuraEnabled
        public emailWrapper emailWrapper;
        @AuraEnabled
        public List<fileWrapper> fileWrapperList;
        @AuraEnabled
        public Boolean fsEditBoolean;
        @AuraEnabled
        public List<fsWrapper> fsWrapperList;

        public wizardWrapper() {
            this.warningMessage = '';
            this.filterArray = new List<String>{'RecordType.Name=\'Lender\''};
            this.selectedEmailList = new List<String>();
            this.emailTemplate = new emailWrapper();
            this.emailWrapper = new emailWrapper();
            this.lenderList = new List<Account>();
            this.fsWrapperList = new List<fsWrapper>();
        }

    }

    public class TC_sendDocsToFundingSourceCTRLException extends Exception {}

}