({
	doInit : function (cmp, event, helper) {
		helper.doInitHelper(cmp);
	},

    toggleAdditionalSection : function(cmp, event, helper) {
       helper.additionalSectionHelper(cmp,event);
    },
    
    setShippingAddress : function (cmp, event, helper) {
        helper.setShippingAddressHelper(cmp);
    },

    addressChangeChooseEvent : function (cmp, event, helper) {
        helper.handleAddressChangeChooseEvent(cmp);
    },

    onBillingStateChange: function (cmp, event) {

        cmp.set('v.wrapper.partnerWrapper.partner.BillingStateCode', cmp.get('v.tempBillingState'));
        var billingBoolean = cmp.get('v.billingBoolean');
        cmp.set('v.billingBoolean', !billingBoolean);

    },

    onShippingStateChange: function (cmp, event) {

        cmp.set('v.wrapper.partnerWrapper.partner.ShippingStateCode', cmp.get('v.tempShippingState'));
        var shippingBoolean = cmp.get('v.shippingBoolean');
        cmp.set('v.shippingBoolean', !shippingBoolean);

    },

    onPhoneChange: function (cmp, event) {
        // console.log(event.getSource().get('v.value'));
         var curVal = event.getSource().get('v.value');
         var val = curVal.replace(/\D/g, '');
         var newVal = '';
         var sizes = [3, 3, 4];

         for (var i in sizes) {
             if (val.length > sizes[i]) {
                 newVal += val.substr(0, sizes[i]) + '-';
                 val = val.substr(sizes[i]);
             } else
                 break;
         }

         newVal += val;
         event.getSource().set('v.value', newVal);
    },

    clearPartner : function (cmp, event, helper) {
        helper.clearPartnerHelper(cmp, event);
    },

    deletePartnerEvent : function (cmp, event, helper) {
        helper.deletePartnerHelper(cmp, event);
    },

})