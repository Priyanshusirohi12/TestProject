/**
 * Created on 1/1/18.
 */
({
    handleSameAddress : function (cmp, event, helper) {
        if (cmp.find("sameAsCompanyAddress").get("v.checked")) {
            var guarantor = cmp.get("v.guarantor");
            var company = cmp.get("v.company");
            guarantor.MailingStreet = company.BillingStreet;
            guarantor.MailingCity = company.BillingCity;
            guarantor.MailingStateCode = company.BillingStateCode;
            guarantor.MailingPostalCode = company.BillingPostalCode;
            guarantor.MailingCountryCode = company.BillingCountryCode;
            cmp.set("v.guarantor", guarantor);
        }
    },

    handleLookupChoose : function (cmp, event, helper) {
        var that = this;
        var guarId = event.getParam('recordId');

        console.log('selectGuarantor', guarId);

        if (guarId) {
            TCLightningUtils.showSpinner(cmp);
            var action = cmp.get('c.selectGuarantor');

            action.setParams({
                guarantorId: guarId
            });

            action.setCallback(this, function (result) {
                TCLightningUtils.hideSpinner(cmp);

                if (result.getState() == 'SUCCESS') {

                    var guarantor = result.getReturnValue();
                    var oldGuar = cmp.get('v.guarantor');

                    for (var g in guarantor) {
                        oldGuar[g] = guarantor[g];
                    }

                    cmp.set('v.guarantor', oldGuar);
                } else {
                    console.log(result.getError());
                    TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');
                }
            });

            $A.enqueueAction(action);
        }
    }
})