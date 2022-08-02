({

    setRelationshipRecordOptions : function (cmp) {

        var action = cmp.get('c.getRecordType');

        action.setCallback(this, function(result) {
            if (result.getState() === 'SUCCESS') {
                var returnValue = result.getReturnValue();
                cmp.set('v.recordTypeMap', returnValue);
            } else {
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    'title': 'Error',
                    'type': 'error',
                    'message': result.getError()[0].message
                });
                toastEvent.fire();
            }

        });

        $A.enqueueAction(action);

    },

    createPGuarantorWrapper : function (cmp) {

        var guarantorWrapper = {};

        var guarantor = {};
        guarantor.sobjectType = 'Relationship__c';
        guarantor.RecordTypeId = cmp.get('v.recordTypeMap')['Individual'];
        guarantor.Relationship_Type__c = 'Personal Guarantee';
        guarantor.Signer__c = false;

        var contact = {AccountId : cmp.get('v.wrapper.companyWrapper.company.Id'), MailingCountryCode : 'US'};
        var account = {Name : cmp.get('v.wrapper.companyWrapper.company.Name'), BillingCountryCode : 'US'};

        contact.Account = account;
        guarantor.Person__r = contact;
        guarantorWrapper.guarantor = guarantor;
        guarantorWrapper.isSelected = true;

        return guarantorWrapper;

    },

    addPGuarantorHelper : function (cmp) {

        var guarantorList = cmp.get('v.wrapper.pguarantorList');
        var guarantorWrapper = this.createPGuarantorWrapper(cmp);
        guarantorList.push(guarantorWrapper);
        cmp.set("v.wrapper.pguarantorList",guarantorList);

    },

    clearPGuarantorHelper : function (cmp, event) {

        var guarantors = cmp.get('v.wrapper.pguarantorList');
        var indexVal = event.getSource().get('v.value');
        var guarantorWrapper = this.createPGuarantorWrapper(cmp);
        guarantors[indexVal] = guarantorWrapper;
        cmp.set('v.wrapper.pguarantorList', guarantors);

    },

    deletePGuarantorHelper : function (cmp, event) {

        var guarantors = cmp.get('v.wrapper.pguarantorList');
        var indexVal = event.getSource().get('v.value');
        guarantors.splice(indexVal, 1);

        cmp.set('v.wrapper.pguarantorList',guarantors);

    },

    createCGuarantorWrapper : function (cmp) {

        var guarantorWrapper = {};
        var guarantor = {};
        guarantor.sobjectType = 'Relationship__c';
        guarantor.RecordTypeId = cmp.get('v.recordTypeMap')['Corporation'];
        guarantor.Relationship_Type__c = 'Business Guarantee';

        guarantorWrapper.guarantor = guarantor;
        guarantorWrapper.isSelected = true;

        return guarantorWrapper;

    },

    addCGuarantorHelper : function (cmp) {

        var guarantorList = cmp.get('v.wrapper.cguarantorList');
        var guarantorWrapper = this.createCGuarantorWrapper(cmp);
        guarantorList.push(guarantorWrapper);
        cmp.set("v.wrapper.cguarantorList",guarantorList);

    },

    clearCGuarantorHelper : function (cmp, event) {

        var guarantors = cmp.get('v.wrapper.cguarantorList');
        var indexVal = event.getSource().get('v.value');
        var guarantorWrapper = this.createCGuarantorWrapper(cmp);
        guarantors[indexVal] = guarantorWrapper;
        cmp.set('v.wrapper.cguarantorList', guarantors);

    },

    deleteCGuarantorHelper : function (cmp, event) {

        var guarantors = cmp.get('v.wrapper.cguarantorList');
        var indexVal = event.getSource().get('v.value');
        guarantors.splice(indexVal, 1);

        cmp.set('v.wrapper.cguarantorList',guarantors);

    },

    handleChooseEventHelper : function (cmp, event) {

        console.log('handling inside parent guarantor');

        var recordId = event.getParam('recordId');
        var objectAPIName = event.getParam('objectAPIName');
        var isPersonal = objectAPIName === 'Contact';

        if (recordId && isPersonal) {

            var action = cmp.get('c.selectPGuarantorCtrl');

            var wrapper = cmp.get('v.wrapper');
            var wrapperString = JSON.stringify(wrapper);
            var index = 0;

            action.setParams({
                wrapperString : wrapperString,
                contactId : recordId,
                index : index
            });

            action.setCallback(this, function(result) {

                if (result.getState() === 'SUCCESS') {

                    cmp.set('v.wrapper', result.getReturnValue());

                } else {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Error',
                        'type': 'error',
                        'message': result.getError()[0].message
                    });
                    toastEvent.fire();
                }

            });

            $A.enqueueAction(action);

        } else if (recordId && !isPersonal) {

            var action = cmp.get('c.selectCGuarantorCtrl');

            var wrapper = cmp.get('v.wrapper');
            var wrapperString = JSON.stringify(wrapper);
            var index = 0;

            action.setParams({
                wrapperString : wrapperString,
                accountId : recordId,
                index : index
            });

            action.setCallback(this, function(result) {

                if (result.getState() === 'SUCCESS') {

                    cmp.set('v.wrapper', result.getReturnValue());

                } else {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Error',
                        'type': 'error',
                        'message': result.getError()[0].message
                    });
                    toastEvent.fire();
                }

            });

            $A.enqueueAction(action);

        }

    },

    checkRequired : function (cmp) {

        // For guarantors, go through guarantorLists and check that LastNames are filled out
        var pguarantorList = cmp.get('v.wrapper.pguarantorList');
        var personalValid = true;
        pguarantorList.forEach(function (item, index) {
            var value = pguarantorList[index].guarantor.Person__r.LastName;
            var boolean = !(value == undefined || value == '') ? true : false;
            personalValid = personalValid && boolean;
        });

        if (!personalValid) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'Error',
                'type': 'error',
                'message': 'Please fill out the missing required fields in Personal Guarantors'
            });
            toastEvent.fire();
        }

        var cguarantorList = cmp.get('v.wrapper.cguarantorList');
        var corporateValid = true;
        cguarantorList.forEach(function (item, index) {
            var value = cguarantorList[index].guarantor.Business__r.Name;
            var boolean = !(value == undefined || value == '') ? true : false;
            corporateValid = corporateValid && boolean;
        });

        if (!corporateValid) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'Error',
                'type': 'error',
                'message': 'Please fill out the missing required fields in Corporate Guarantors'
            });
            toastEvent.fire();
        }

        return personalValid && corporateValid;

    },

    checkPersonalGuarantorAccount : function (cmp) {

        var noCompanyBoolean = false;
        var diffAccountBoolean = false;

        // For personal guarantors, go through guarantorLists and check that the Account is the same as the deal company
        var company = cmp.get('v.wrapper.companyWrapper.company');

        var pguarantorList = cmp.get('v.wrapper.pguarantorList');
        pguarantorList.forEach(function (item, index) {
            if (company == null && item.guarantor.Person__r.Id == null) {
                noCompanyBoolean = true;
            }
            else if (company != null && company.Name != undefined && item.guarantor.Person__r.Account != null &&
                    item.guarantor.Person__r.Account.Name != null && company.Name != item.guarantor.Person__r.Account.Name) {
                diffAccountBoolean = true;
            }
        });

        var companyPguarantorList = cmp.get('v.wrapper.companyPguarantorList');
        companyPguarantorList.forEach(function (item, index) {
            if (item.isSelected && company != null && company.Name != undefined &&
                    (item.guarantor.Person__r.Account == undefined ||
                    (item.guarantor.Person__r.Account.Name != undefined && company.Name != item.guarantor.Person__r.Account.Name))) {
                diffAccountBoolean = true;
            }
        });

        if (diffAccountBoolean) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'mode': 'sticky',
                'title': 'Warning',
                'type': 'warning',
                'message': 'The Personal Guarantor Contact(s) you selected are associated with a different Customer ' +
                    'than the Customer you selected for this Deal'
            });
            toastEvent.fire();
        } if (noCompanyBoolean) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'mode': 'sticky',
                'title': 'Warning',
                'type': 'warning',
                'message': 'New Personal Guarantor Contacts have no Account because no Deal Customer has been added'
            });
            toastEvent.fire();
        }

        return true;

    },

    saveAndPreviousHelper : function (cmp, event, helper) {
        if (this.checkRequired(cmp) && this.checkPersonalGuarantorAccount(cmp)) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'previous'
            });
            navigateEvent.fire();
        }
    },

    saveAndNextHelper : function (cmp, event, helper) {
        if (this.checkRequired(cmp) && this.checkPersonalGuarantorAccount(cmp)) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'next'
            });
            navigateEvent.fire();
        }
    },

    reviewAndSaveHelper : function (cmp, event, helper) {
        if (this.checkRequired(cmp) && this.checkPersonalGuarantorAccount(cmp)) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'submit'
            });
            navigateEvent.fire();
        }
    },

    clearAllEventHelper : function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": cmp.get('v.wrapper.cancelButtonURL')
        });
        urlEvent.fire();
    },

    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true);
    },

    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },

})