({
    addGuarantor: function (cmp) {
        console.log('addGuarantor');
        var guarantors = cmp.get("v.guarantors");

        var guarantor = {};
        guarantor.sobjectType = 'Contact';
        guarantor.MailingCountryCode = 'US';
        
        guarantors.push(guarantor);
        console.log(guarantors);
        cmp.set("v.guarantors",guarantors);
    },

    deleteGuarantor: function (cmp, event, helper) {
        var guarantors = cmp.get("v.guarantors");
        var indexVal = event.getSource().get('v.value');
        guarantors.pop(indexVal);
        console.log(guarantors);
        cmp.set("v.guarantors",guarantors);
    },

    quickSave : function (cmp, event, helper) {
        TCLightningUtils.showSpinner(cmp);
        var action;
        var company = cmp.get('v.company');
        var guarantors = cmp.get('v.guarantors');

        console.log('save guarantors', guarantors);

        action = cmp.get('c.saveGuarantors');
        guarantors.forEach(function (el) {
            el.AccountId = company.Id;
        });

        action.setParams({
            guarantors: guarantors
        });

        action.setCallback(this, function (result) {
            TCLightningUtils.hideSpinner(cmp);
            if (result.getState() === 'SUCCESS') {
                cmp.set('v.guarantors', result.getReturnValue());
                TCLightningUtils.showToast('Success', 'Records saved.', 'success');
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');

            }
        });
        $A.enqueueAction(action);
    },
})