({
	changeOwner : function(cmp, event, helper) {
		var action = cmp.get('c.setOwnerId');
        console.log('Selected User Id: '+cmp.get('v.selectedUserId'));
        action.setParams({
            recordId: cmp.get("v.recordId"),
            userId : cmp.get("v.selectedUserId")
        });
        action.setCallback(this, function(result) {
            if (result.getState() === "SUCCESS") {
                var returnedValue = result.getReturnValue();
                //cmp.set('v.Opportunity', returnedValue);
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
        			"title": "Success!",
                    'type': 'success',
        			"message": "The opportunity owner has been changed successfully."
    			});
    			toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            } else {
                var error = result.getError();          
            }
        });
        
        $A.enqueueAction(action);
    },
	
    getOpportunity : function(cmp, event, helper){
        console.log('In getOpportunity');
        var action = cmp.get('c.getOpportunity');
        action.setParams({
            recordId : cmp.get('v.recordId')
        });
        action.setCallback(this, function(result){
            if (result.getState(0 === "SUCCESS")){
                console.log('In success');
                var returnedValue = result.getReturnValue();
                cmp.set('v.opportunity', returnedValue);
            } else {
                var error = result.getError();
            }
        });
        $A.enqueueAction(action);
    }
})