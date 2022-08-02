/**
 * Created by szheng on 2019-11-23.
 */

({

	addEmailClick : function(cmp, event, helper) {
        helper.addEmailClickHelper(cmp, event);
    },

    handleLenderChooseEvent : function(cmp, event, helper) {
        helper.handleLenderChooseEventHelper(cmp, event);
    },

    handleCheckboxChange : function(cmp, event, helper) {
        helper.setFundingSourceRecords(cmp);
    },
    
});