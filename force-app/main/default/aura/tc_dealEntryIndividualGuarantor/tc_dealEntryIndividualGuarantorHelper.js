({

	additionalSectionHelper : function(cmp,event) {
        var acc = cmp.find('additionalSection');
        for (var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');
            $A.util.toggleClass(acc[cmp], 'slds-hide');
        }
	},

    handleChooseEventHelper : function (cmp, event) {

        event.stopPropagation();

        var recordId = event.getParam('recordId');
        var objectAPIName = event.getParam('objectAPIName');
        var isPersonal = objectAPIName === 'Contact';

        var wrapper = cmp.get('v.wrapper');

        if (recordId && isPersonal) {

            var action = cmp.get('c.selectPGuarantorCtrl');

            action.setParams({
                wrapperString : JSON.stringify(wrapper),
                contactId : recordId,
                index : cmp.get('v.index')
            });

            action.setCallback(this, function(result) {

                if (result.getState() === 'SUCCESS') {
                    cmp.set('v.wrapper', result.getReturnValue());
                    this.handleAddressChangeChooseEvent(cmp);
                } else {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Error',
                        'type': 'error',
                        'message': result.getError()[0].message
                    });
                    toastEvent.fire();
                }

            });

            $A.enqueueAction(action);

        } else if (recordId && !isPersonal) {

            var action = cmp.get('c.selectCGuarantorCtrl');

            action.setParams({
                wrapperString : JSON.stringify(wrapper),
                accountId : recordId,
                index : cmp.get('v.index')
            });

            action.setCallback(this, function(result) {

                if (result.getState() === 'SUCCESS') {
                    cmp.set('v.wrapper', result.getReturnValue());
                    this.handleAddressChangeChooseEvent(cmp);
                } else {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Error',
                        'type': 'error',
                        'message': result.getError()[0].message
                    });
                    toastEvent.fire();
                }

            });

            $A.enqueueAction(action);

        }

    },

    handleAddressChangeChooseEvent : function (cmp) {

        var guarantorWrapper = cmp.get('v.guarantorWrapper');
        var guarantor = guarantorWrapper.guarantor;
        var isPersonal = cmp.get('v.isPersonal');

        if (isPersonal && guarantor.Person__r != undefined) {
            if (guarantor.Person__r.MailingCountryCode == undefined) {
                cmp.set('v.guarantorWrapper.guarantor.Person__r.MailingCountryCode', '');
            }
            if (guarantor.Person__r.MailingStateCode != undefined) {
                cmp.set('v.tempState', guarantor.Person__r.MailingStateCode);
            }
        } else if (!isPersonal && guarantor.Business__r != undefined) {
            if (guarantor.Business__r.BillingCountryCode == undefined) {
                cmp.set('v.guarantorWrapper.guarantor.Business__r.BillingCountryCode', '');
            }
            if (guarantor.Business__r.BillingStateCode != undefined) {
                cmp.set('v.tempState', guarantor.Business__r.BillingStateCode);
            }
        }

    },

    onStateChangeHelper : function (cmp) {

        var isPersonal = cmp.get('v.isPersonal');
        var tempState = cmp.get('v.tempState');
        var index = cmp.get('v.index');
        var isAccountRelated = cmp.get('v.guarantorWrapper.isAccountRelated');

        if (isPersonal) {

            var pguarantorList = isAccountRelated ? cmp.get('v.wrapper.companyPguarantorList') : cmp.get('v.wrapper.pguarantorList');
            pguarantorList[index].guarantor.Person__r.MailingStateCode = tempState;
            if (isAccountRelated) {
                cmp.set('v.wrapper.companyPguarantorList', pguarantorList);
            } else {
                cmp.set('v.wrapper.pguarantorList', pguarantorList);
            }

        } else {

            var cguarantorList = isAccountRelated ? cmp.get('v.wrapper.companyCguarantorList') : cmp.get('v.wrapper.cguarantorList');
            cguarantorList[index].guarantor.Business__r.BillingStateCode = tempState;
            if (isAccountRelated) {
                cmp.set('v.wrapper.companyCguarantorList', cguarantorList);
            } else {
                cmp.set('v.wrapper.cguarantorList', cguarantorList);
            }

        }

        cmp.set('v.stateBoolean', !cmp.get('v.stateBoolean'));

    }
})