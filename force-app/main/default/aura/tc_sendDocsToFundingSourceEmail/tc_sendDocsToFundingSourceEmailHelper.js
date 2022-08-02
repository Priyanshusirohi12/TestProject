/**
 * Created by tamarack on 2019-11-07.
 */

({

    updateEmailHelper : function(cmp, event) {

        var wrapper = cmp.get('v.wrapper');

        var fileWrapperList = wrapper.fileWrapperList;
        var selectedFileWrapperList = new Array();
        fileWrapperList.forEach(function(item, index) {
            if (item.isSelected) {
                selectedFileWrapperList.push(item);
            }
        });
        cmp.set('v.selectedFileWrapperList', selectedFileWrapperList);

        var selectedEmailList = wrapper.selectedEmailList;
        cmp.set('v.selectedEmailString', selectedEmailList.join(', '));

        if (wrapper.emailTemplate.templateValue == 'Default') {
            wrapper.emailWrapper.subject = cmp.get('v.wrapper.emailTemplate.subject');
            wrapper.emailWrapper.htmlBody = cmp.get('v.wrapper.emailTemplate.htmlBody');
        } else {
            wrapper.emailWrapper.subject = cmp.get('v.wrapper.emailTemplate.customSubject');
            wrapper.emailWrapper.htmlBody = cmp.get('v.wrapper.emailTemplate.customHtmlBody');
        }

        cmp.set('v.wrapper', wrapper);

    },

    sendEmailHelper : function(cmp, event) {

        var validateInput = this.validateInput(cmp);
        if (validateInput) {

            var action = cmp.get('c.sendEmailWithFiles');

            var sendEmailMapParams = new Map();
            sendEmailMapParams['fileWrapperListString'] = JSON.stringify(cmp.get('v.selectedFileWrapperList'));
            sendEmailMapParams['selectedEmailListString'] = JSON.stringify(cmp.get('v.wrapper.selectedEmailList'));
            sendEmailMapParams['emailWrapperString'] = JSON.stringify(cmp.get('v.wrapper.emailWrapper'));
            sendEmailMapParams['fsWrapperListString'] = JSON.stringify(cmp.get('v.wrapper.fsWrapperList'));

            var sendEmailMapParamsString = JSON.stringify(sendEmailMapParams);

            action.setParams({
                sendEmailMapParamsString : sendEmailMapParamsString
            });

            action.setCallback(this, function(result) {
                if (result.getState() === "SUCCESS") {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Success',
                        'type': 'success',
                        'message': 'Email submitted successfully!'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                } else {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'mode': 'sticky',
                        'title': 'Error',
                        'type': 'Error',
                        'message': 'Email not submitted successfully: ' + result.getReturnValue()
                    });
                    toastEvent.fire();
                }
            });

            $A.enqueueAction(action);

        }

    },

    validateInput : function(cmp) {

        var validateInputBoolean = true;
        if (cmp.get('v.wrapper.selectedEmailList') == '') {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'mode': 'sticky',
                'title': 'Error',
                'type': 'Error',
                'message': 'No recipients selected.'
            });
            toastEvent.fire();
            validateInputBoolean = false;
        }

        return validateInputBoolean;

    },

});