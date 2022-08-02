({

    addCompany : function (cmp, event, helper) {
        helper.addCompanyHelper(cmp);
    },

    handleCompanyChooseEvent : function (cmp,event,helper) {
        helper.handleCompanyChooseEventHelper(cmp, event);
    },

    handleDeleteRecordEvent : function (cmp, event, helper) {
        helper.handleDeleteRecordEventHelper(cmp, event);
    },

    saveAndPrevious: function (cmp, event, helper) {
        helper.saveAndPreviousHelper(cmp, event, helper);
    },

    saveAndNext: function (cmp, event, helper) {
        helper.saveAndNextHelper(cmp, event, helper);
    },

    reviewAndSave: function (cmp, event, helper) {
        helper.reviewAndSaveHelper(cmp, event, helper);
    },

    clearAllEvent : function (cmp, event, helper) {
        helper.clearAllEventHelper(cmp, event, helper);
    },

})