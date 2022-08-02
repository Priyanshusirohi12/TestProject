/**
 * Created by tamarack on 12/30/19.
 */

({
	init : function(cmp, event, helper) {
	 	helper.grabWrapper(cmp, event, helper);
	},

    handlePrint : function(cmp, event, helper) {
        window.print();
    },

});