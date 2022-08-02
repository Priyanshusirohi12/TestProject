({
    doInit : function(cmp, event, helper) {
        helper.setRelationshipRecordOptions(cmp);
    },

	addPGuarantor : function(cmp, event, helper) {
        helper.addPGuarantorHelper(cmp);
    },

    clearPGuarantor : function(cmp, event, helper) {
        helper.clearPGuarantorHelper(cmp, event);
    },

    deletePGuarantor : function(cmp, event, helper) {
        helper.deletePGuarantorHelper(cmp, event);
    },

    addCGuarantor : function(cmp, event, helper) {
        helper.addCGuarantorHelper(cmp);
    },

    clearCGuarantor : function(cmp, event, helper) {
        helper.clearCGuarantorHelper(cmp, event);
    },

    deleteCGuarantor : function(cmp, event, helper) {
        helper.deleteCGuarantorHelper(cmp, event);
    },

    handleChooseEvent : function (cmp, event, helper) {
        helper.handleChooseEventHelper(cmp, event);
    },

    saveAndPrevious: function(cmp, event, helper) {
        helper.saveAndPreviousHelper(cmp, event, helper);
    },

    saveAndNext: function(cmp, event, helper) {
        helper.saveAndNextHelper(cmp, event, helper);
    },

    reviewAndSave: function (cmp, event, helper) {
        helper.reviewAndSaveHelper(cmp, event, helper);
    },

    clearAllEvent : function (cmp, event, helper) {
        helper.clearAllEventHelper(cmp, event, helper);
    }

})