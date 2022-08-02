({
	doInit : function(cmp, event, helper) {
		helper.doInitHelper(cmp, event);
	},

	setRecordTab : function(cmp) {
	    cmp.set('v.renderRecords', !cmp.get('v.renderRecords'));
    },

	setReviewTab : function(cmp) {
	    cmp.find('emailComponent').updateEmail();
    },

    handleRecordClick : function (cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})