/**
 * Created by tamarack on 2019-07-18.
 */

public without sharing class TC_OnlineApplicationPDFCtrl {

    public TC_OnlineApplicationCtrl ctrlWrapper {get; set;}
    public List<ContentDocument> filesList {get; set;}
    public String submittedByVendorName {get; set;}

    public TC_OnlineApplicationPDFCtrl() {

        try {

            List<Lead> requeriedLeadList = new List<Lead>([SELECT Id FROM Lead ORDER BY LastModifiedDate DESC LIMIT 1]);
            System.debug('TC_OnlineApplicationPDFCtrl - Requeried last modified lead: ' + requeriedLeadList);

            PageReference p = ApexPages.currentPage();
            System.debug(p.getParameters());
            String leadId = p.getParameters().get('leadId');
            String partnerCode = p.getParameters().get('partnerCode');
            String vendorId = p.getParameters().get('vendorId');

            List<Id> cdIdList = p.getParameters().get('cdList').split(',');
            filesList = new List<ContentDocument>([SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN: cdIdList]);

            if (leadId == null || partnerCode == null) {
                String errorMessage = 'Online Application PDF requires a leadId and partnerCode URL parameter to generate the PDF, but did not find one.';
                throw new TC_OnlineApplicationPDFCtrlException(errorMessage);
            }

            ctrlWrapper = new TC_OnlineApplicationCtrl();
            ctrlWrapper.leadId = leadId;
            ctrlWrapper.partnerCode = partnerCode;
            ctrlWrapper.vendorId = vendorId;
            ctrlWrapper.warningMessageList = new List<String>();

            System.debug('PDF controller - ctrlWrapper.leadId: ' + ctrlWrapper.leadId);

            // Get Application Program sections & field labels
            TC_OnlineApplicationInitCtrl.getApplicationProgram(ctrlWrapper);
            // For reference in later function, get state & country picklist information
            TC_OnlineApplicationInitCtrl.getStateCountryPicklistInformation(ctrlWrapper);
            // Get Online Application settings, such as disclosure text & custom fields
            TC_OnlineApplicationInitCtrl.getAppSettingInformation(ctrlWrapper);
            // Populate ctrlWrapper with lead information
            TC_OnlineApplicationInitCtrl.getLeadInformation('', ctrlWrapper);

            List<Lead> leadList = new List<Lead>([SELECT Id, Submitted_by_Vendor__r.Name FROM Lead WHERE Id =: leadId]);
            submittedByVendorName = (!leadList.isEmpty()) ? leadList[0].Submitted_by_Vendor__r.Name : null;

            System.debug('businessSectionWrapper: ' + ctrlWrapper.businessSectionWrapper);

        } catch (Exception e) {
            System.debug(e.getStackTraceString());
            throw new TC_OnlineApplicationPDFCtrlException(e.getMessage());
        }


    }

    public class TC_OnlineApplicationPDFCtrlException extends Exception {}
}