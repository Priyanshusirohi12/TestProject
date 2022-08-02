({
    runFlow : function(cmp) {

        var action = cmp.get('c.runFlow');
        action.setParams({
            recordId : cmp.get("v.recordId")
        });

        var help = this;

        action.setCallback(this, function(result) {

            help.hideSpinner(cmp);

            if(result.getState() === 'SUCCESS') {
                cmp.set('v.message', result.getReturnValue());
                $A.get('e.force:refreshView').fire();
            } else {
                cmp.set('v.message', result.getError()[0].message);
            }
        });

        $A.enqueueAction(action);

    },

    hideSpinner : function (cmp) {
        cmp.set('v.showSpinner', 0);
    }
})