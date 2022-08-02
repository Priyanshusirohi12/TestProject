/**
 * Created on 12/7/17.
 */
({
    doInit : function (cmp, event, helper) {
        console.log('doInit theme');
        var action = cmp.get('c.populateUserInfo');

        action.setCallback(this, function (result) {

            if (result.getState() === 'SUCCESS') {
                cmp.set('v.userInfo', result.getReturnValue());
            } else {
                alert ('error on init - ' + result.getError()[0].message);
            }

        });

        $A.enqueueAction(action);
    }
})