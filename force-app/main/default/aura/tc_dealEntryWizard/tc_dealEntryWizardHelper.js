({
	doInitHelper : function (cmp) {

        var action = cmp.get('c.initMethod');
        action.setCallback(this, function(result) {
            if (result.getState() === 'SUCCESS') {
                cmp.set('v.wrapper', result.getReturnValue());
            } else {
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    'title': 'Error',
                    'type': 'error',
                    'message': result.getError()[0].message
                });
                toastEvent.fire();
                cmp.set('v.spinner', false);
            }
        });
        $A.enqueueAction(action);

        var tabMap = new Object();
        tabMap['deal'] = 'step_1';
        tabMap['company'] = 'step_2';
        tabMap['guarantors'] = 'step_3';
        tabMap['equipment'] = 'step_4';
        tabMap['partner'] = 'step_5';
        cmp.set('v.tabMap', tabMap);

	},

	handleTabNavigationHelper : function (cmp, event) {

	    var direction = event.getParam('tabDirection');
        var currentStep = cmp.get('v.currentStep');
        var newStep;
        var stepIndex = currentStep.split('_')[1];

        if (direction === 'next') {
            stepIndex++;
            newStep = 'step_' + stepIndex;
        }
        else if (direction === 'previous') {
            stepIndex--;
            newStep = 'step_' + stepIndex;
        }
        else if (direction === 'submit') {
            newStep = 'step_6';
        } else {
            var tabMap = cmp.get('v.tabMap');
            newStep = tabMap[direction];
        }

        var cmpSource = cmp.find(currentStep);
        $A.util.addClass(cmpSource, 'slds-hide');
        var cmpSourceTab = cmp.find(currentStep + 'Tab');
        $A.util.addClass(cmpSourceTab, 'unselectedTab');
        $A.util.removeClass(cmpSourceTab, 'selectedTab');

        var cmpTarget = cmp.find(newStep);
        $A.util.removeClass(cmpTarget, 'slds-hide');
        var cmpTargetTab = cmp.find(newStep + 'Tab');
        $A.util.addClass(cmpTargetTab, 'selectedTab');
        $A.util.removeClass(cmpTargetTab, 'unselectedTab');
        cmp.set('v.currentStep', newStep);

        if (newStep == 'step_3' || newStep == 'guarantor') {
            // For re-rendering the new personal guarantor account/deal company
            cmp.set('v.guarantorBoolean', !cmp.get('v.guarantorBoolean'));
        } else if (newStep == 'step_6' || newStep == 'submit') {
            // For re-rendering the Submit page after making changes to the deal
            cmp.set('v.submitBoolean', !cmp.get('v.submitBoolean'));
        }

    },

})