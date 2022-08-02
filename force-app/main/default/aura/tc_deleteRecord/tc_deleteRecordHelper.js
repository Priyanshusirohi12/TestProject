({
	deleteRecord : function(cmp) {
		var action = cmp.get('c.deleteRecordById');
        action.setParams({
            recordId: cmp.get('v.recordId')
        });
        
        action.setCallback(this, function (result) {
            
            var spinner = cmp.find("spinner");
        	$A.util.toggleClass(spinner, 'slds-hide');
            
            if (result.getState() === 'SUCCESS') {
				this.showToast('Success', 'Record Deleted', 'success', 'sticky');
                this.redirectToListView (cmp);
            } else {
                console.log(result.getError());
                this.showToast('Error', result.getError()[0].message, 'error', 'sticky');
            }
        });

        $A.enqueueAction(action);
	},
    showToast : function(title, message, type, mode) {
        var toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type': type,
            'mode': mode
        });
        
        toastEvent.fire();
    },
    redirectToListView : function (cmp) {
        
        var action = cmp.get("c.getListViewId");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var scope = cmp.get ('v.sObjectName');
                $A.get('e.force:refreshView').fire();
                var lvId = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": lvId,
                    "listViewName": null,
                    "scope": scope
                });
            	navEvent.fire();
        	}
    	});
    	$A.enqueueAction(action);
    }
})