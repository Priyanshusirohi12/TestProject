({

    addPartner : function (cmp, event, helper) {
        helper.addPartnerHelper(cmp);
    },

    handleChooseEvent : function (cmp,event,helper) {
        helper.handleChooseEventHelper(cmp, event);
    },

    handleDeleteRecordEvent : function (cmp, event, helper) {
        helper.handleDeleteRecordEventHelper(cmp, event);
    },

    saveAndPrevious: function(cmp, event, helper) {
        helper.saveAndPreviousHelper(cmp, event, helper);
    },

    reviewAndSave: function (cmp, event, helper) {
        helper.reviewAndSaveHelper(cmp, event, helper);
    },

    clearAllEvent : function (cmp, event, helper) {
        helper.clearAllEventHelper(cmp, event, helper);
    }

})