/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-21
 * Description: 
 */
({
    getTemplates : function (cmp) {
        var action = cmp.get('c.getTemplates');
        action.setParams({
            oppId : cmp.get('v.recordId')
        });

        action.setCallback(this, function(result) {
            if(result.getState() === 'SUCCESS') {

                var template = JSON.parse(result.getReturnValue());
                console.log('Getting template values...');

                cmp.set('v.templates', template.envelopeTemplates);
                console.log('temps from ctrl: ', cmp.get('v.templates'));
            } else {
                console.log('Error: ', result.getError());
            }
        });

        $A.enqueueAction(action);

    },

    getSigners : function (cmp) {
        var action = cmp.get('c.getSigners');
        action.setParams({
            oppId : cmp.get('v.recordId')
        });

        action.setCallback(this, function(result) {
            if(result.getState() === 'SUCCESS') {
                console.log('Getting signer values...');

                var rels = JSON.parse(result.getReturnValue());
                cmp.set('v.relList', rels);
                cmp.set('v.showSpinner', 0);
            }else {
                console.log('Error: ', result.getError());
            }
        });

        $A.enqueueAction(action);

    },

    getUserInfos : function(cmp) {
        var action = cmp.get('c.getUserandAccountInformation');

        action.setParams({
            oppId : cmp.get('v.recordId')
        });
        console.log('inside get acc');
        action.setCallback(this, function(result) {
            if(result.getState() === 'SUCCESS') {
                console.log('getting user infos...');

                var account = JSON.parse(result.getReturnValue()[0]);
                var partnerAccountId = result.getReturnValue()[1];
                var csName = result.getReturnValue()[2];

                cmp.set('v.account', account);
                cmp.set('v.partnerAccountId', partnerAccountId);
                cmp.set('v.counterSignerName', csName);
                console.log('cmp pai ' + cmp.get('v.partnerAccountId'));
            } else {
                console.log('ERROR: ', result.getError());
            }
        });

        $A.enqueueAction(action);
    },

    sendForSignature : function (cmp) {
        var action = cmp.get('c.send');
        action.setParams({
            oppId : cmp.get('v.recordId'),
            subject : cmp.get('v.subject'),
            body : cmp.get('v.body'),
            templateIds : cmp.get('v.templateIds'),
            relJSON : JSON.stringify(cmp.get('v.selectedRel')),
            counterSignerId : cmp.get('v.counterSigner'),
            partnerAccountId : cmp.get('v.partnerAccountId')
        });

        action.setCallback(this, function(result) {
            if(result.getState() === 'SUCCESS'){
                console.log('Send Successful');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Success!",
                    "message" : "Your document is out for signature.",
                    "type" : "success"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            } else {
                console.table(result.getError());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Error:",
                    "message" : result.getError()[0].message,
                    "type" : "error"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });

        $A.enqueueAction(action);
        cmp.set('v.showSpinner',1);
    },


})