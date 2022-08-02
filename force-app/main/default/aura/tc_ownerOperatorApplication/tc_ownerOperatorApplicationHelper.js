/**
 * Created on 2018-11-21.
 */
({
    showToast : function(title,message, _type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "mode" : mode ? mode : 'dismissible',
            "type": _type ? _type : 'error'
        });
        toastEvent.fire();
    },

    checkFields : function (cmp, event) {
        var allValid = cmp.find('requiredField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        var guarValid = true;

        if (cmp.find('guarantor')) {
            if (typeof cmp.find('guarantor').getConcreteComponent === 'undefined') { //then it's an array
                guarValid = cmp.find('guarantor').reduce(function (validSoFar, inputCmp) {
                    var valid = inputCmp.validateData();
                    return validSoFar && valid;
                }, true);
            } else {
                guarValid = cmp.find('guarantor').validateData();
            }
        }
        return allValid && guarValid;
    },

    submitApp : function (cmp) {
        var action = cmp.get('c.createOwnerOperatorLead');
        var that = this;
        var documentIds = [];
        var documentNames = '';
        var uploadedFiles = cmp.get('v.uploadedFiles');
        var lead =  cmp.get('v.lead');
        lead.Authorized_Credit_Check__c = cmp.find('authorizedCheck').get("v.value");
        console.log(lead.Authorized_Credit_Check__c);

        if (!lead.Address) {
            that.showToast('Error', 'Address is required.', 'error');
        } else {
            lead.Date_of_Birth_1__c = cmp.get('v.dateOfBirth');

            uploadedFiles.forEach(function (item) {
                documentIds.push(item.documentId);
                documentNames = documentNames + '/' + item.name;
            });

            action.setParams({
                l: lead,
                leadOwnerId: cmp.get('v.partner').group.Id,
                documentIds:documentIds,
                leadSourceId: cmp.get('v.leadSourceId'),
            });

            action.setCallback(this, function (result) {
                if (result.getState() === 'SUCCESS') {
                    var action2 = cmp.get('c.generateOnlineApplicationPDF');
                    action2.setParams({
                        leadId : result.getReturnValue(),
                        logoURL : cmp.get('v.logoUrl'),
                        partnerCode : cmp.get('v.partnerCode'),
                        documentNames : documentNames,
                        isStandard : false});
                    action2.setCallback(this, function (result2) {
                        console.log(result2.getState());
                        if (result2.getState() === 'SUCCESS') {
                            that.showToast('Success', 'Your application has been submitted. Reference number  ' + result.getReturnValue(), 'success', 'sticky');
                            cmp.destroy();
                        } else {
                            console.log(result2.getError()[0].message);
                            that.showToast('Error', result2.getError()[0].message, 'error');
                        }
                    });
                    $A.enqueueAction(action2);

                } else {

                    that.showToast('Error', result.getError()[0].message, 'error');
                }
            });

            $A.enqueueAction(action);
        }
    },


    findPartnerInfo : function (cmp) {
        var action = cmp.get('c.getPartnerInformation');
        var that = this;
        action.setParams({
            partnerCode: cmp.get('v.partnerCode')
        });

        action.setCallback(this, function (result) {

            if (result.getState() === 'SUCCESS') {
                var partnerInfo = JSON.parse(result.getReturnValue());
                cmp.set('v.partner', partnerInfo);
                console.log(partnerInfo);

                var siteConfig = partnerInfo.siteConfig;
                cmp.set('v.disclosureText', siteConfig.Disclosure_Text__c);
                cmp.set('v.logoUrl', siteConfig.Logo_Url__c);
                cmp.set('v.customFields', partnerInfo.customFields);
                cmp.set('v.currentUserId', partnerInfo.currentUserId);
                cmp.set('v.showAdditionalFieldSection', partnerInfo.showAdditionalFieldSection);
            } else {
                that.showToast('Error', result.getError()[0].message, 'error', 'sticky');
                cmp.destroy();
            }
        });
        $A.enqueueAction(action);
    }
})