({
    addGuarantor: function (cmp, event, helper) {
        helper.addGuarantor(cmp);
    },

    doInit : function (cmp, event, helper) {
        var guarantors = cmp.get("v.guarantors");
        
        if (guarantors.length == 0)
            helper.addGuarantor(cmp);
    },

    deleteItem : function (cmp, event, helper) {
        helper.deleteGuarantor(cmp, event, helper);
    },

    clearItem : function (cmp, event, helper) {
        var guarantors = cmp.get("v.guarantors");

        var indexVal = event.getSource().get('v.value');

        var guarantor = {};
        guarantor.sobjectType = 'Contact';
        guarantor.MailingCountryCode = 'US';
        guarantors[indexVal] = guarantor;
        console.log(guarantors);
        cmp.set("v.guarantors",guarantors);
    },

    quickSave : function (cmp, event, helper) {
        helper.quickSave (cmp, event, helper);
    },

    goToNext : function (cmp, event, helper) {
        var navEvent = $A.get("e.c:tc_applicationNavigation_evt");
        var dir = "next";
        
        navEvent.setParams({
            data: {
                direction: dir
            }
        });
        
        navEvent.fire();
    }
})