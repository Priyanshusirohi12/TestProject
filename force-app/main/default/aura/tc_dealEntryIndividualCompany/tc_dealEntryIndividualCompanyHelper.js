({
    doInitHelper : function (cmp) {

        cmp.set('v.shippingSameAsBilling', true);
        cmp.set('v.wrapper.companyWrapper.company.BillingCountryCode', 'US');
        cmp.set('v.wrapper.companyWrapper.company.ShippingCountryCode', 'US');

        var action = cmp.get('c.getRecordTypeId');
        action.setCallback(this, function(result) {
            var returnValue = result.getReturnValue();
            cmp.set('v.wrapper.companyWrapper.company.RecordTypeId', returnValue);
        });
        $A.enqueueAction(action);

    },

    setShippingAddressHelper : function(cmp) {

        var company = cmp.get('v.wrapper.companyWrapper.company');
        if (company == null || company.Id != null) return;

        var shippingSameAsBilling = cmp.get('v.shippingSameAsBilling');
        if (shippingSameAsBilling) {
            cmp.set('v.wrapper.companyWrapper.company.ShippingStreet', cmp.get('v.wrapper.companyWrapper.company.BillingStreet'));
            cmp.set('v.wrapper.companyWrapper.company.ShippingCity', cmp.get('v.wrapper.companyWrapper.company.BillingCity'));
            cmp.set('v.wrapper.companyWrapper.company.ShippingStateCode', cmp.get('v.wrapper.companyWrapper.company.BillingStateCode'));
            cmp.set('v.wrapper.companyWrapper.company.ShippingPostalCode', cmp.get('v.wrapper.companyWrapper.company.BillingPostalCode'));
            cmp.set('v.wrapper.companyWrapper.company.ShippingCountryCode', cmp.get('v.wrapper.companyWrapper.company.ShippingCountryCode'));
        }

    },

    handleAddressChangeChooseEvent : function (cmp) {

        var company = cmp.get('v.wrapper.companyWrapper.company');

        if (company.BillingCountryCode == undefined) {
            cmp.set('v.wrapper.companyWrapper.company.BillingCountryCode', '');
        }
        if (company.ShippingCountryCode == undefined) {
            cmp.set('v.wrapper.companyWrapper.company.ShippingCountryCode', '');
        }
        cmp.set('v.tempBillingState', company.BillingStateCode);
        cmp.set('v.tempShippingState', company.ShippingStateCode);

        cmp.set('v.shippingSameAsBilling', false);

    },

	additionalSectionHelper : function(cmp,event) {
        var toggleBoolean = cmp.get('v.toggleAdditionalDetails');
        cmp.set('v.toggleAdditionalDetails', !toggleBoolean);

        var acc = cmp.find('additionalSection');
        for (var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');
            $A.util.toggleClass(acc[cmp], 'slds-hide');
        }
	},

    clearCompanyHelper : function (cmp) {

        cmp.set('v.wrapper.companyWrapper.company', {'sobjectType' : 'Account'});
        cmp.set('v.wrapper.companyWrapper.readOnly', false);
        cmp.set('v.tempShippingState', '');
        cmp.set('v.tempBillingState', '');
        this.doInitHelper(cmp);

    },

    deleteCompanyHelper : function (cmp, event) {

        var cmpEvent = cmp.getEvent('deleteRecord');
        cmpEvent.fire();

    },

})