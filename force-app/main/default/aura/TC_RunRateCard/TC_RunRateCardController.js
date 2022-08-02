({
    doInit : function (cmp, event, helper) {
        helper.runFlow(cmp);
    },

    isRefreshed : function (cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})