/**
 * Created on 2018-11-21.
 */
({

    doInitHelper : function(cmp) {

        var urlParameters = this.parseURLParameters(cmp);
        console.log('partnerCode: ' + cmp.get('v.partnerCode') + ' - vendorId: ' + cmp.get('v.vendorId') + ' - leadId: ' + cmp.get('v.leadId'));

        var action = cmp.get('c.doApplicationInit');
        action.setParams({
            partnerCode: cmp.get('v.partnerCode'),
            vendorId: cmp.get('v.vendorId'),
            leadId : cmp.get('v.leadId'),
            urlParameters: urlParameters
        });

        action.setCallback(this, function (result) {
            if (result.getState() === 'SUCCESS') {
                cmp.set('v.wrapper', result.getReturnValue());
                cmp.set('v.initDone', true);
                var warningMessageList = result.getReturnValue().warningMessageList;
                warningMessageList.forEach(function(item, index) {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Warning',
                        'type': 'warning',
                        'message': item
                    });
                    toastEvent.fire();
                })
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "type": "Error",
                    "message": result.getError()[0].message
                });
                toastEvent.fire();
                cmp.destroy();
            }
        });
        $A.enqueueAction(action);
    },

    parseURLParameters : function(cmp) {
        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m, key, value) {
            vars[key.toLowerCase()] = value;
        });

        if (vars.hasOwnProperty('partnercode')) {
            cmp.set('v.partnerCode', vars['partnercode']);
            delete vars['partnercode'];
        }
        if (vars.hasOwnProperty('leadid')) {
            cmp.set('v.leadId', vars['leadid']);
            delete vars['leadid'];
        }
        if (vars.hasOwnProperty('vendorid')) {
            cmp.set('v.vendorId', vars['vendorid']);
            delete vars['vendorid'];
        }
        return JSON.stringify(vars);
    },

    handleUploadFinishedHelper : function(cmp, event) {
        var uploadedFiles = event.getParam('files');
        var action = cmp.get("c.getFiles");
        action.setParams({
            "recordId" : cmp.get('v.wrapper.currentUserId')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS'){
                var result = response.getReturnValue();

                var documentObject = result[0];
                var files = cmp.get('v.files');
                files[documentObject.Id] = documentObject;
                cmp.set("v.files",files);

                var filesList = [];
                Object.keys(files).forEach(function(key) {
                    filesList.push(files[key]);
                });
                cmp.set('v.wrapper.filesList', filesList);
            } else {
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    'title': 'Error',
                    'type': 'error',
                    'message': response.getError()[0].message
                });
                toastEvent.fire();
                cmp.set('v.spinner', false);
            }
        });
        $A.enqueueAction(action);
    },

    delUploadedfiles : function(cmp,documentId) {
        var action = cmp.get("c.deleteFiles");
        action.setParams({
            "cdId":documentId
        });
        action.setCallback(this,function(response) {
            if (response.getState() === 'SUCCESS') {
                var files = cmp.get('v.files');

                Object.keys(files).forEach(function (key) {
                 if(key == documentId) delete files[key];
                });
                cmp.set('v.files', files);

                var filesList = [];
                Object.keys(files).forEach(function(key) {
                    filesList.push(files[key]);
                });
                cmp.set('v.wrapper.filesList', filesList);

                //cmp.set("v.spinner", false);
            } else {
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    'title': 'Error',
                    'type': 'error',
                    'message': response.getError()[0].message
                });
                toastEvent.fire();
                //cmp.set('v.spinner', false);
            }
        });
        $A.enqueueAction(action);
    },

    submitApplicationHelper : function(cmp, event) {
        if (!this.validateFields(cmp, event)) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'Error',
                'type': 'error',
                'message': 'Please complete the missing fields.'
            });
            toastEvent.fire();
        } else {
            var action = cmp.get('c.submitCommercialApplication');
            action.setParams({
                wrapperString : JSON.stringify(cmp.get('v.wrapper'))
            });

            action.setCallback(this, function (result) {
                //console.log('result.getState(): ' + result.getState());
                if (result.getState() === 'SUCCESS') {
                    cmp.set('v.displayThankYou', true);
                    cmp.set('v.wrapper', result.getReturnValue());
                    console.log('Submitted leadId: ' + cmp.get('v.wrapper.leadId'));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "type": "Success",
                        "message": 'Your lead has been successfully submitted!'
                    });
                    toastEvent.fire();
                    this.submitApplicationFollowUp(cmp, event);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "type": "Error",
                        "message": result.getError()[0].message
                    });
                    toastEvent.fire();
                    //cmp.destroy();
                }
            });
            $A.enqueueAction(action);
        }
    },

    submitApplicationFollowUp : function(cmp, event) {
        var action = cmp.get('c.submitFollowUp');
        action.setParams({
            wrapperString : JSON.stringify(cmp.get('v.wrapper'))
        });

        action.setCallback(this, function (result) {
            if (result.getState() === 'SUCCESS') {
                if (result.getReturnValue() != null) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning",
                        "type": "warning",
                        "message": result.getReturnValue()
                    });
                    toastEvent.fire();
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "type": "Error",
                    "message": result.getError()[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    validateFields : function(cmp, event) {
        var onlineAppSectionsValid = cmp.find('onlineAppSection').reduce(function (validSoFar, inputCmp) {
            var validSection = inputCmp.fieldValidation();
            return validSoFar && validSection;
        }, true);
        var authorizedCheckValid = cmp.find('required').get('v.checked');
        if (!authorizedCheckValid) cmp.find('required').showHelpMessageIfInvalid();
        return onlineAppSectionsValid && authorizedCheckValid;
    }

})