({
    doInitHelper : function(cmp, event) {

		var action = cmp.get('c.setWizardWrapper');
        action.setParams({
            recordId: cmp.get("v.recordId")
        });
        action.setCallback(this, function(result) {
            if (result.getState() === "SUCCESS") {
                cmp.set('v.wrapper', result.getReturnValue());
            } else {
                this.showToast('Error', 'error', result.getError()[0].message);
            }
        });

        $A.enqueueAction(action);

        cmp.set('v.parentRendered', !cmp.get('v.parentRendered'));

    },
    
    showToast : function(title, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'type': type,
            'message': message
        });
        toastEvent.fire();
    }
})