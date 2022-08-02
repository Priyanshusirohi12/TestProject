({

    addPartnerHelper : function(cmp) {

        cmp.set("v.wrapper.partnerWrapper.partner", {'sobjectType' : 'Account', 'ShippingCountryCode' : 'US', 'BillingCountryCode' : 'US'});
        cmp.find('partnerButton').set('v.disabled', true);

    },

    handleChooseEventHelper : function (cmp, event) {

        var recordId = event.getParam('recordId');

        if (recordId) {

            var action = cmp.get('c.selectPartner');

            action.setParams({
                partnerId : recordId
            });

            action.setCallback(this, function(result) {

                if (result.getState() === 'SUCCESS') {
                    var partner = result.getReturnValue();
                    cmp.set('v.wrapper.partnerWrapper.partner', partner);

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

    handleDeleteRecordEventHelper : function (cmp, event) {
        cmp.set('v.wrapper.partnerWrapper.partner', null);
    },

    setShippingAddress : function (cmp) {
        if (cmp.get('v.wrapper.partnerWrapper.partner') != null
            && cmp.get('v.wrapper.partnerWrapper.partner.Id') == null) {
            var childLightningComponent = cmp.find('childLightningComponent');
            childLightningComponent.setShippingAddress();
        }
    },

    checkRequired : function (cmp) {

        var partner = cmp.get('v.wrapper.partnerWrapper.partner');
        if (partner == null || Object.keys(partner).length === 0) return true;

        var value = cmp.get('v.wrapper.partnerWrapper.partner.Name');
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

    saveAndPreviousHelper : function (cmp, event, helper) {

        if (this.saveHelper(cmp)) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'previous'
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
            var partner = cmp.get('v.wrapper.partnerWrapper.partner');
            if (partner != null
                && Object.keys(partner).length > 0
                && cmp.get('v.wrapper.partnerWrapper.partner.Id') == null) {
                this.setShippingAddress(cmp);
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