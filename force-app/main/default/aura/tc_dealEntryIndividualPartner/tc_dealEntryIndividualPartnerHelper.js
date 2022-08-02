({
    doInitHelper : function(cmp) {

        cmp.set('v.shippingSameAsBilling', true);
        cmp.set('v.wrapper.partnerWrapper.partner.BillingCountryCode', 'US');
        cmp.set('v.wrapper.partnerWrapper.partner.ShippingCountryCode', 'US');

        var action = cmp.get('c.getRecordTypeId');
        action.setCallback(this, function(result) {
            var returnValue = result.getReturnValue();
            cmp.set('v.wrapper.partnerWrapper.partner.RecordTypeId', returnValue);
        });
        $A.enqueueAction(action);
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

    setShippingAddressHelper : function (cmp) {

        var partner = cmp.get('v.wrapper.partnerWrapper.partner');
        if (partner == null || partner.Id != null) return;

        var shippingBoolean = cmp.get('v.shippingSameAsBilling');
        if (shippingBoolean) {
            cmp.set('v.wrapper.partnerWrapper.partner.ShippingStreet', cmp.get('v.wrapper.partnerWrapper.partner.BillingStreet'));
            cmp.set('v.wrapper.partnerWrapper.partner.ShippingCity', cmp.get('v.wrapper.partnerWrapper.partner.BillingCity'));
            cmp.set('v.wrapper.partnerWrapper.partner.ShippingStateCode', cmp.get('v.wrapper.partnerWrapper.partner.BillingStateCode'));
            cmp.set('v.wrapper.partnerWrapper.partner.ShippingPostalCode', cmp.get('v.wrapper.partnerWrapper.partner.BillingPostalCode'));
            cmp.set('v.wrapper.partnerWrapper.partner.ShippingCountryCode', cmp.get('v.wrapper.partnerWrapper.partner.ShippingCountryCode'));
        }

    },

    handleAddressChangeChooseEvent : function (cmp) {

        var partner = cmp.get('v.wrapper.partnerWrapper.partner');

        if (partner.BillingCountryCode == undefined) {
            cmp.set('v.wrapper.partnerWrapper.partner.BillingCountryCode', '');
        }
        if (partner.ShippingCountryCode == undefined) {
            cmp.set('v.wrapper.partnerWrapper.partner.ShippingCountryCode', '');
        }

        cmp.set('v.tempBillingState', cmp.get('v.wrapper.partnerWrapper.partner.BillingStateCode'));
        cmp.set('v.tempShippingState', cmp.get('v.wrapper.partnerWrapper.partner.ShippingStateCode'));
        cmp.set('v.billingBoolean', !cmp.get('v.billingBoolean'));

        cmp.set('v.wrapper.partnerWrapper.readOnly', true);
        cmp.set('v.shippingSameAsBilling', false);

    },

    handleRecordTypeChooseEvent : function (cmp, recordTypeId) {

        var recordTypeMap = cmp.get('v.recordTypeMap');
        var recordTypeName = Object.keys(recordTypeMap).find(key => recordTypeMap[key] === recordTypeId);

        cmp.set('v.recordTemp', recordTypeName);
        var recordBoolean = cmp.get('v.recordBoolean');
        cmp.set('v.recordBoolean', !recordBoolean);

    },

    clearPartnerHelper : function (cmp) {
        cmp.set('v.wrapper.partnerWrapper.partner', {'sobjectType' : 'Account'});
        cmp.set('v.wrapper.partnerWrapper.readOnly', false);
        this.doInitHelper(cmp);
    },

    deletePartnerHelper : function (cmp, event) {

        cmp.set('v.wrapper.partnerWrapper.readOnly', false);
        var cmpEvent = cmp.getEvent('deleteRecord');
        cmpEvent.fire();

    },

})