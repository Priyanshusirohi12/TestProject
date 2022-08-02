({
    quickSave: function (cmp, event, helper) {
        TCLightningUtils.showSpinner(cmp);
        var action;
        var company = cmp.get('v.company');


        action = cmp.get('c.saveCompany');
        action.setParams({
            companyStr: JSON.stringify(company)
        })

        action.setCallback(this, function (result) {
            TCLightningUtils.hideSpinner(cmp);
            if (result.getState() === 'SUCCESS') {
                cmp.set('v.company', result.getReturnValue());
                TCLightningUtils.showToast('Success', 'Record saved.', 'success');
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');
            }
        });
        $A.enqueueAction(action);
    },

    validateRecord: function (cmp, event, helper) {
        return true;
    },

    selectCompany: function (cmp, event) {

        var companyId = event.getParam('recordId');

        if (companyId) {
            console.log('selectCompany');
            TCLightningUtils.showSpinner(cmp);
            var action = cmp.get('c.selectCompany');

            action.setParams({
                companyId: companyId
            });

            action.setCallback(this, function (result) {
                TCLightningUtils.hideSpinner(cmp);

                if (result.getState() == 'SUCCESS') {
                    var company = result.getReturnValue();
                    cmp.set('v.company', company);

                } else {
                    console.log(result.getError());
                    TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');
                }
            });
            $A.enqueueAction(action);
        }
    }

})