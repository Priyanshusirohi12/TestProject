({

	submitDeal : function(cmp, event, helper) {
	    helper.submitDealHelper(cmp);
    },

    handleEditDeal : function (cmp, event, helper) {
        var navigateEvent = cmp.getEvent("changeTab");
        navigateEvent.setParams({
            'tabDirection' : 'deal'
        });
        navigateEvent.fire();
    },

    handleEditCompany : function (cmp, event, helper) {
        var navigateEvent = cmp.getEvent("changeTab");
        navigateEvent.setParams({
            'tabDirection' : 'company'
        });
        navigateEvent.fire();
    },

    handleEditGuarantors : function (cmp, event, helper) {
        var navigateEvent = cmp.getEvent("changeTab");
        navigateEvent.setParams({
            'tabDirection' : 'guarantors'
        });
        navigateEvent.fire();
    },

    handleEditEquipment : function (cmp, event, helper) {
        var navigateEvent = cmp.getEvent("changeTab");
        navigateEvent.setParams({
            'tabDirection' : 'equipment'
        });
        navigateEvent.fire();
    },

    handleEditPartner : function (cmp, event, helper) {
        var navigateEvent = cmp.getEvent("changeTab");
        navigateEvent.setParams({
            'tabDirection' : 'partner'
        });
        navigateEvent.fire();
    },

    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true);
    },

    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },

    clearAllEvent : function (cmp, event, helper) {
        helper.clearAllEventHelper(cmp, event, helper);
    }

})