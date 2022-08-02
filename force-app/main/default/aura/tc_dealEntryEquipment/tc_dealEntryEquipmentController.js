({

	addEquipment : function(cmp, event, helper) {
	    helper.addEquipmentHelper(cmp);
    },

    clearEquipment : function(cmp, event, helper) {
        helper.clearEquipmentHelper(cmp, event);
    },

    deleteEquipment : function(cmp, event, helper) {
        helper.deleteEquipmentHelper(cmp, event);
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