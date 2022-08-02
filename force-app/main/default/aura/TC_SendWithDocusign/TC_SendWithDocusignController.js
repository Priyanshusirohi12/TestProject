/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-21
 * Description: 
 */
({
    doInit : function (cmp, event, helper) {
        helper.getTemplates(cmp);
        helper.getSigners(cmp);
        helper.getUserInfos(cmp);
    },

    onTemplateSelect : function (cmp, event, helper) {
        var template = event.getSource().get("v.value");
        var selected = template.selected;


        if(selected){

        }
        var tempId = cmp.find('pick').get('v.value');
        cmp.set('v.templateId', tempId);
    },

    sendForSignature : function (cmp, event, helper) {
        console.log('v.templateIds' + cmp.get('v.templateIds'));
        console.log('v.selectedRel' + cmp.get('v.selectedRel'));
        console.log('v.counterSigner' + cmp.get('v.counterSigner'));
        if(cmp.get('v.templateIds') == '' && cmp.get('v.selectedRel') == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title" : "Error",
                "message" : "You need to select at least one template and one signer.",
                "type" : "error"
            });
            toastEvent.fire();
        }else if(cmp.get('v.templateIds') == '' && cmp.get('v.selectedRel') != '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title" : "Error",
                "message" : "You need to select at least one template.",
                "type" : "error"
            });
            toastEvent.fire();
        } else if(cmp.get('v.templateIds') != '' && cmp.get('v.selectedRel') == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title" : "Error",
                "message" : "You need to select at least one signer.",
                "type" : "error"
            });
            toastEvent.fire();
        } else {
            helper.sendForSignature(cmp);
        }
    },

})