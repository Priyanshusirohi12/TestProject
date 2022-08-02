/**
 * Created on 11/16/18.
 */
({
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true);
    },

    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },

    doInit: function(cmp, event, helper) {
        helper.doInitHelper(cmp);
    },

    addGuarantor: function(cmp, event, helper) {
        var guarantors = cmp.get('v.wrapper.guarantorSectionWrapperList');
        if (guarantors.length < 3) {
            guarantors.push(JSON.parse(JSON.stringify(cmp.get('v.wrapper.guarantorSectionWrapperTemplate'))));
            cmp.set('v.wrapper.guarantorSectionWrapperList', guarantors);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "type": "Error",
                "message": "You can only add up to three guarantors."
            });
            toastEvent.fire();
        }
    },

    removeGuarantor: function(cmp, event, helper) {
        var index = event.getSource().get("v.value");
        var guarantors = cmp.get('v.wrapper.guarantorSectionWrapperList');
        guarantors.splice(index, 1);
        cmp.set('v.wrapper.guarantorSectionWrapperList', guarantors);
    },

    addEquipment: function(cmp, event, helper) {
        var equipment = cmp.get('v.wrapper.equipmentSectionWrapperList');
        if (equipment.length < 3) {
            equipment.push(JSON.parse(JSON.stringify(cmp.get('v.wrapper.equipmentSectionWrapperTemplate'))));
            cmp.set('v.wrapper.equipmentSectionWrapperList', equipment);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "type": "Error",
                "message": "You can only add up to three pieces of equipment."
            });
            toastEvent.fire();
        }
    },

    removeEquipment: function(cmp, event, helper) {
        var index = event.getSource().get("v.value");
        var equipment = cmp.get('v.wrapper.equipmentSectionWrapperList');
        equipment.splice(index, 1);
        cmp.set('v.wrapper.equipmentSectionWrapperList', equipment);
    },

    handleUploadFinished : function(cmp, event, helper) {
        helper.handleUploadFinishedHelper(cmp, event);
    },

    previewFile : function(cmp, event, helper) {
        var rec_id = event.currentTarget.id;
        $A.get('e.lightning:openFiles').fire({
            recordIds: [rec_id]
        });
    },

    delFiles: function(cmp, event, helper){
        var documentId = event.currentTarget.id;
        helper.delUploadedfiles(cmp, documentId);
    },

    submitApplication : function(cmp, event, helper) {
        helper.submitApplicationHelper(cmp, event);
    },

})