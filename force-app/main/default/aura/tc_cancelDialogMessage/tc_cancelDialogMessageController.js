/**
 * Created on 12/30/17.
 */
({
    doConfirm : function (cmp, event, helper) {
        var confirmAction = cmp.get('v.confirmAction');
        confirmAction();
    },

    doCancel : function (cmp, event, helper) {
        cmp.find("overlayLib").notifyClose();
    }
})