/**
 * Created by tamarack on 2019-11-06.
 */

({

    doInit : function(cmp, event, helper) {

        var topicName = cmp.get('v.parentRendered');

        if (topicName) {
            helper.updateEmailHelper(cmp, event);
        }

    },

    sendEmail : function(cmp, event, helper) {
        helper.sendEmailHelper(cmp, event);
    },

    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true);
    },

    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },

});