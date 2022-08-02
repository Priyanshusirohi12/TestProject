({

    addCompanyHelper : function(cmp) {

        var company = {'sobjectType' : 'Account', 'ShippingCountryCode' : 'US', 'BillingCountryCode' : 'US'};
        cmp.set("v.wrapper.companyWrapper.company", company);

    },

    handleCompanyChooseEventHelper : function (cmp, event) {

        var companyId = event.getParam('recordId');

        if (companyId) {

            if (cmp.get('v.wrapper.companyWrapper.company') == null) {
                this.addCompanyHelper(cmp);
            }

            cmp.set('v.wrapper.companyWrapper.company.Id', companyId);
            var wrapper = cmp.get('v.wrapper');
            var wrapperString = JSON.stringify(wrapper);

            var action = cmp.get('c.selectCompany');
            action.setParams({
                wrapperString : wrapperString
            });
            action.setCallback(this, function(result) {

                if (result.getState() === 'SUCCESS') {
                    var wrapper = result.getReturnValue();
                    cmp.set('v.wrapper', wrapper);

                    var childLightningComponent = cmp.find('childLightningComponent');
                    childLightningComponent.addressChangeChooseEvent();
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

        var company = cmp.get('v.wrapper.companyWrapper.company');
        if (company == null || Object.keys(company).length === 0) return true;

        var value = cmp.get('v.wrapper.companyWrapper.company.Name');
        var inputValid = !(value == undefined || value == null || value === '') ? true : false;

        if (!inputValid) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'Error',
                'type': 'error',
                'message': 'Please fill out the missing required fields'
            });
            toastEvent.fire();
        }

        return inputValid;

    },

    handleDeleteRecordEventHelper : function (cmp, event) {
        cmp.set('v.wrapper.companyWrapper.company', null);
        cmp.set('v.wrapper.companyWrapper.readOnly', false);
        cmp.set('v.wrapper.companyPguarantorList', []);
        cmp.set('v.wrapper.companyPgSelected', 0);
        cmp.set('v.wrapper.companyCguarantorList', []);
        cmp.set('v.wrapper.companyCgSelected', 0);
    },

    updatePGAccount : function (cmp) {

        var pguarantorList = cmp.get('v.wrapper.pguarantorList');
        var accountId = cmp.get('v.wrapper.companyWrapper.company.Id');
        var accountName = cmp.get('v.wrapper.companyWrapper.company.Name');
        pguarantorList.forEach(function (item, index) {
            if (item.guarantor.Person__r.Id == null) {
                item.guarantor.Person__r.AccountId = accountId;
                item.guarantor.Person__r.Account.Name = accountName;
            }
        });

        cmp.set('v.wrapper.pguarantorList', pguarantorList);

    },

    setShippingAddress : function (cmp) {
        if (cmp.get('v.wrapper.companyWrapper.company') != null
            && cmp.get('v.wrapper.companyWrapper.company.Id') == null) {
            var childLightningComponent = cmp.find('childLightningComponent');
            childLightningComponent.setShippingAddress();
        }
    },

    saveAndPreviousHelper : function (cmp, event, helper) {
        if (this.saveHelper(cmp)) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'previous'
            });
            navigateEvent.fire();
        }
    },

    saveAndNextHelper : function (cmp, event, helper) {
        if (this.saveHelper(cmp)) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'next'
            });
            navigateEvent.fire();
        }
    },

    reviewAndSaveHelper : function (cmp, event, helper) {
        if (this.saveHelper(cmp)) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'submit'
            });
            navigateEvent.fire();
        }
    },

    saveHelper : function (cmp) {
        if (this.checkRequired(cmp)) {
            this.updatePGAccount(cmp);
            var company = cmp.get('v.wrapper.companyWrapper.company');
            if (company != null && Object.keys(company).length > 0) {
                if (cmp.get('v.wrapper.companyWrapper.company.Id') == null) {
                    this.setShippingAddress(cmp);
                }
            }
            return true;
        }
        return false;
    },

    clearAllEventHelper : function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": cmp.get('v.wrapper.cancelButtonURL')
        });
        urlEvent.fire();
    }

})