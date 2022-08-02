({

    checkRequired : function (cmp) {

        var inputValid = cmp.find('requiredField').reduce(function (validSoFar, inputCmp) {
            var value = inputCmp.get('v.value');
            var boolean = !(value == undefined || value == null || value === '') ? true : false;
            return validSoFar && boolean;
        }, true);

        if (!inputValid) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'Error',
                'type': 'error',
                'message': 'Please fill out the missing required fields'
            });
            toastEvent.fire();
        }

        return inputValid;

    },

    saveAndNextHelper : function (cmp, event, helper) {
        var checkBoolean = this.checkRequired(cmp);
        if (checkBoolean) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'next'
            });
            navigateEvent.fire();
        }
    },

    reviewAndSaveHelper : function (cmp, event, helper) {
        var checkBoolean = this.checkRequired(cmp);
        if (checkBoolean) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'submit'
            });
            navigateEvent.fire();
        }
    },

    clearAllEventHelper : function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": cmp.get('v.wrapper.cancelButtonURL')
        });
        urlEvent.fire();
    }

})