({

	submitDealHelper : function (cmp) {

		var wrapper = cmp.get('v.wrapper');
		var deal = wrapper.dealWrapper.deal;
		if (deal.Name == null || deal.CloseDate == null || deal.StageName == '') {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'Error',
                'type': 'error',
                'message': 'Please fill out the missing required fields in the Deal tab'
            });
            toastEvent.fire();
            return;
        }

        var dealString = JSON.stringify(deal);

		var companyString = JSON.stringify(wrapper.companyWrapper.company);

        var companyPguarantorList = [];
        wrapper.companyPguarantorList.forEach(function (item, index) {
            if (item.isSelected) {
                companyPguarantorList.push(item.guarantor);
            }
        });
        var companyPguarantorString = JSON.stringify(companyPguarantorList);

        var companyCguarantorList = [];
        wrapper.companyCguarantorList.forEach(function (item, index) {
            if (item.isSelected) {
                companyCguarantorList.push(item.guarantor);
            }
        });
        var companyCguarantorString = JSON.stringify(companyCguarantorList);

		var pguarantorList = [];
        wrapper.pguarantorList.forEach(function (item, index) {
            pguarantorList.push(item.guarantor);
        });
		var pguarantorString = JSON.stringify(pguarantorList);
		console.log('pguarantorString: ' + pguarantorString);

		var cguarantorList = [];
        wrapper.cguarantorList.forEach(function (item, index) {
            cguarantorList.push(item.guarantor);
        });
        var cguarantorString = JSON.stringify(cguarantorList);

		var equipmentString = JSON.stringify(wrapper.equipmentList);

		var partnerString = JSON.stringify(wrapper.partnerWrapper.partner);

        var action = cmp.get('c.submitDealCtrl');

        action.setParams({
            dealString : dealString,
            companyString : companyString,
            companyPguarantorString : companyPguarantorString,
            companyCguarantorString : companyCguarantorString,
            pguarantorString : pguarantorString,
            cguarantorString : cguarantorString,
            equipmentString : equipmentString,
            partnerString : partnerString
        });

        action.setCallback(this, function(result) {

            if (result.getState() === 'SUCCESS') {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": result.getReturnValue()
                });
                navEvt.fire();
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

	},

    clearAllEventHelper : function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": cmp.get('v.wrapper.cancelButtonURL')
        });
        urlEvent.fire();
    }

})