({
	doInit : function (cmp, event, helper) {
	    helper.doInitHelper(cmp);
	},

    toggleAdditionalSection : function(cmp, event, helper) {
       helper.additionalSectionHelper(cmp,event);
    },

    addressChangeChooseEvent : function (cmp, event, helper) {
        helper.handleAddressChangeChooseEvent(cmp);
    },

    setShippingAddress : function (cmp, event, helper) {
        helper.setShippingAddressHelper(cmp);
    },

    onBillingStateChange : function (cmp, event) {
        cmp.set('v.wrapper.companyWrapper.company.BillingStateCode', cmp.get('v.tempBillingState'));
        var billingBoolean = cmp.get('v.billingBoolean');
        cmp.set('v.billingBoolean', !billingBoolean);
    },

    onShippingStateChange : function (cmp, event) {
        cmp.set('v.wrapper.companyWrapper.company.ShippingStateCode', cmp.get('v.tempShippingState'));
        var shippingBoolean = cmp.get('v.shippingBoolean');
        cmp.set('v.shippingBoolean', !shippingBoolean);
    },

    onPhoneChange: function (cmp, event) {

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

    clearCompany : function (cmp, event, helper) {
        helper.clearCompanyHelper(cmp, event);
    },

    deleteCompanyEvent : function (cmp, event, helper) {
        helper.deleteCompanyHelper(cmp, event);
    },
   
})