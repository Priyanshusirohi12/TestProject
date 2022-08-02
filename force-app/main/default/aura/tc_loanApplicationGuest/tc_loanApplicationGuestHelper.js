/**
 * Created on 12/19/17.
 */
({
    getPageParameters: function (cmp) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var pageParams = {};

        sURLVariables.forEach(function (val) {
            pageParams[val.split('=')[0]] = val.split('=')[1];
        });

        return pageParams;
    },

    refreshDealGuarantorsView : function (cmp) {
        var dealGuarantorsComp = cmp.find('dealGuarantorsComp');
        dealGuarantorsComp.set('v.company', cmp.get('v.company'));
        dealGuarantorsComp.set('v.guarantors', cmp.get('v.guarantors'));
    },

    refreshDealEquipmentView : function (cmp) {
        var dealEquipmentComp = cmp.find('dealEquipmentComp');
        dealEquipmentComp.set('v.company', cmp.get('v.company'));
        dealEquipmentComp.set('v.equipmentList', cmp.get('v.equipmentList'));
        dealEquipmentComp.set('v.deal', cmp.get('v.deal'));
    },

    refreshView : function (cmp) {
        var dealReviewComp = cmp.find('dealReviewComp');
        dealReviewComp.set('v.company', cmp.get('v.company'));
        dealReviewComp.set('v.guarantors', cmp.get('v.guarantors'));
        dealReviewComp.set('v.quoteOptions', cmp.get('v.quoteOptions'));
        dealReviewComp.set('v.equipmentList', cmp.get('v.equipmentList'));
        dealReviewComp.set('v.deal', cmp.get('v.deal'));
        dealReviewComp.set('v.totalFinanceAmount', cmp.get('v.totalFinanceAmount'));
        var docComp = cmp.find('dealDocs');
        console.log('refreshView', docComp.get('v.fileList'));
        dealReviewComp.set('v.docs', docComp.get('v.fileList'));
    },

    refreshDealDetailsView : function (cmp) {
        var dealDetailsComp = cmp.find('dealDetailsComp');
        dealDetailsComp.set('v.deal', cmp.get('v.deal'));
        dealDetailsComp.set('v.totalFinanceAmount', cmp.get('v.totalFinanceAmount'));
    },

    calculateTotalFinanceAmount : function (cmp) {
        var totalFinanceAmount = 0;
        var equipmentList = cmp.get("v.equipmentList");

        for (var i = 0; i < equipmentList.length; i++) {
            var equipment = equipmentList[i];

            if(equipment.Cost_Per_Unit__c != null && equipment.Quantity__c != null)
                totalFinanceAmount += (equipment.Cost_Per_Unit__c * equipment.Quantity__c);
        }

        cmp.set("v.totalFinanceAmount", totalFinanceAmount);
    },

    getApplicationRecordById: function (cmp) {
        console.log('getApplicationRecordById', cmp.get('v.recordId'));
        var action = cmp.get('c.getApplicationById');

        action.setParams({
            appId: cmp.get('v.recordId')
        });

        action.setCallback(this, function (result) {

            if (result.getState() === 'SUCCESS') {
                var appInfo = JSON.parse(result.getReturnValue());
                console.log('getApplicationRecordById appInfo', appInfo);
                cmp.set('v.deal', appInfo.deal);
                cmp.set('v.company', appInfo.company);
                cmp.set('v.quoteOptions', appInfo.quoteOptions);
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].message, 'error', 'sticky');
            }
        });

        $A.enqueueAction(action);

    },

    submitDeal: function (cmp) {

        var deal = cmp.get('v.deal');
        console.log('submitDeal start', deal);

        TCLightningUtils.showSpinner(cmp);
        var action = cmp.get('c.submitApplication');
        console.log('action', action);

        action.setParams({
            companyString: JSON.stringify(cmp.get('v.company')),
            guarantors: JSON.stringify(cmp.get('v.guarantors')),
            equipmentList: cmp.get('v.equipmentList'),
            dealString: JSON.stringify(deal)
        });

        console.log('action setparams');

        action.setCallback(this, function (result) {
            console.log('action setCallback');
            TCLightningUtils.hideSpinner(cmp);
            if (result.getState() === 'SUCCESS') {
                TCLightningUtils.showToast('Success', 'Deal Submitted.', 'success');
                this.navigateToHome();
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');
            }
        });

        $A.enqueueAction(action);
    },

    navigateToHome: function () {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    }
})