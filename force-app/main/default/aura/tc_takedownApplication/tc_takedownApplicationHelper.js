({
    getCompanyRecordById: function (cmp) {
        console.log('getCompanyRecordById', cmp.get('v.recordId'));
        var action = cmp.get('c.getCompanyRecordById');

        action.setParams({
            recordId: cmp.get('v.recordId'),
            isTakedown: true
        });

        action.setCallback(this, function (result) {

            if (result.getState() === 'SUCCESS') {
                var appInfo = JSON.parse(result.getReturnValue());
                console.log('getCompanyRecordById appInfo', appInfo);
                cmp.set('v.deal', appInfo.deal);
                cmp.set('v.company', appInfo.company);
                cmp.set('v.guarantors', appInfo.guarantors);
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].getMessage(), 'error', 'sticky');
            }
        });

        $A.enqueueAction(action);
    },
    
    setIsMasterLine: function (cmp) {
        console.log('setIsMasterLine', cmp.get('v.recordId'));
        var action = cmp.get('c.setIsMasterLine');

        action.setParams({
            recordId: cmp.get('v.recordId')
        });

        action.setCallback(this, function (result) {

            if (result.getState() === 'SUCCESS') {
                cmp.set('v.isMasterLine', result.getReturnValue());
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].getMessage(), 'error', 'sticky');
            }
        });

        $A.enqueueAction(action);
    }
})