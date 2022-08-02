/**
 * Created by szheng on 2019-11-23.
 */

({

    parseEmailTemplate : function(cmp) {

        var templateName = cmp.get('v.wrapper.emailTemplate.templateName');
        var templateOptions = [
            {'label':'Default Template (' + templateName + ')', 'value':'Default'},
            {'label':'Custom Template', 'value':'Custom'}
        ];
        cmp.set('v.templateOptions', templateOptions);
        cmp.set('v.wrapper.emailTemplate.templateValue', 'Default');

    },

    displayWarningMessage : function(cmp) {

        var warningMessage = cmp.get('v.wrapper.warningMessage');
        if (warningMessage != '') {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'mode': 'sticky',
                'title': 'Warning',
                'type': 'warning',
                'message': warningMessage
            });
            toastEvent.fire();
        }

    }

});