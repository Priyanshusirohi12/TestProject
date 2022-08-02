/**
 * Created by tamarack on 12/31/19.
 */

({

	grabWrapper : function(cmp, event, helper) {

		var action = cmp.get('c.grabDocWrapper');
        action.setParams({
            recordId: cmp.get("v.recordId")
        });

        action.setCallback(this, function(result) {
            if (result.getState() === "SUCCESS") {
                var returnedValue = result.getReturnValue();
                cmp.set('v.wrapper', returnedValue);
            } else {
                var error = result.getError();
                console.log('ERROR: ' + error);
            }
        });

        $A.enqueueAction(action);
	},

});