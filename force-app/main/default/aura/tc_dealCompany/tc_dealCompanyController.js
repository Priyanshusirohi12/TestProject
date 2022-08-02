({
    quickSave : function (cmp, event, helper) {
        helper.quickSave(cmp, event, helper);
    },

    clearCompany: function (cmp, event, helper) {
        var company = {};
        company.sobjectType = 'Account';
        company.BillingCountryCode = 'US';
        company.Status__c = 'Applicant';
        cmp.set("v.company", company);
    },

    //Function to handle the LookupChooseEvent. Sets the chosen record.
    handleCompanyChoose: function (cmp, event, helper) {
        helper.selectCompany(cmp, event);
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