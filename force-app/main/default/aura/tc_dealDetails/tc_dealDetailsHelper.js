/**
 * Created on 12/30/17.
 */
({
    getQuoteOptions : function (cmp) {
        var action = cmp.get('c.getQuoteOptionsByDealId');
        action.setParams ({
            dealId: cmp.get('v.deal').Id
        });
        console.log(cmp.get('v.deal').Id);
        action.setCallback(this, function (result) {
            if (result.getState() === 'SUCCESS') {
                console.log(result.getReturnValue());
                cmp.set('v.quoteOptions', result.getReturnValue());
            } else {
                console.log(result.getError());
            }
        });

        $A.enqueueAction (action);
    },
    
    setMasterLine : function (cmp) {
        var action = cmp.get('c.getMasterLine');
        
        action.setParams ({
            masterLineId: cmp.get('v.masterLineId')
        });
        
        action.setCallback(this, function (result) {
            if (result.getState() === 'SUCCESS') {
                cmp.set('v.masterLine', result.getReturnValue());
            } else {
                console.log(result.getError());
            }
        });

        $A.enqueueAction (action);
    },
    
    quickSave : function (cmp, event, helper) {
        TCLightningUtils.showSpinner(cmp);
        var action;
        var deal = cmp.get('v.deal');


        action = cmp.get('c.saveDeal');
        action.setParams({
            dealString: JSON.stringify(deal)
        })

        action.setCallback(this, function (result) {
            TCLightningUtils.hideSpinner(cmp);
            if (result.getState() === 'SUCCESS') {
                console.log(result.getReturnValue());
                cmp.set('v.deal', result.getReturnValue());
                TCLightningUtils.showToast('Success', 'Record saved.', 'success');
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');

            }
        });
        $A.enqueueAction(action);
    }
})