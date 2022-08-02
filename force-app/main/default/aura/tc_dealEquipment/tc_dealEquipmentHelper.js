/**
 * Created on 1/2/18.
 */
({
    addEquipment: function (cmp) {
        var quoteOptions = cmp.get("v.quoteOptions");
        var equipmentList = cmp.get("v.equipmentList");
        var equipment = {sobjectType: 'Equipment__c'};
        equipment.Name = 'Description';


        console.log('addEquipment quoteOptions', quoteOptions);

        if (equipmentList.length < 1 && quoteOptions.length > 0) {
            quoteOptions.forEach(function (qo) {
                if (qo.Include_in_Quote__c) {
                    equipment.Quantity__c = 1;
                    equipment.Cost_Per_Unit__c = qo.Finance_Amount__c;
                }

            });
        }

        equipmentList.push(equipment);
        cmp.set("v.equipmentList", equipmentList);
    },

    quickSave: function (cmp, event, helper) {



        TCLightningUtils.showSpinner(cmp);
        var action = cmp.get('c.saveEquipment');
        var company = cmp.get('v.company');
        var equipment = cmp.get('v.equipmentList');
        var deal = cmp.get('v.deal');
        deal.AccountId = company.Id;
        delete deal.attributes;
        console.log('eq quick save equipmentList', equipment);
        console.log('eq quick save deal string', JSON.stringify(deal));

        action.setParams({
            equipment: equipment,
            dealString: JSON.stringify(deal)
        });

        action.setCallback(this, function (result) {
            TCLightningUtils.hideSpinner(cmp);

            
            if (result.getState() === 'SUCCESS') {
                console.log('eq quick save return', result.getReturnValue());
                cmp.set('v.equipmentList', result.getReturnValue().equipment);
                cmp.set('v.deal', result.getReturnValue().deal);
                TCLightningUtils.showToast('Success', 'Records saved.', 'success');
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');
            }
        });
        $A.enqueueAction(action);
    },

    goToNext: function (cmp, event, helper) {
        var navEvent = $A.get("e.c:tc_applicationNavigation_evt");
        var dir = "next";

        navEvent.setParams({
            data: {
                direction: dir
            }
        });

        navEvent.fire();
    },
    
    getPicklists: function (cmp) {
        var action = cmp.get('c.getDependentPicklists');

        action.setParams({
        });

        action.setCallback(this, function (result) {
            console.log('getPicklists', result.getReturnValue());
            
            if (result.getState() === 'SUCCESS') {
                cmp.set('v.picklists', result.getReturnValue());
            } else {
                console.log(result.getError());
                TCLightningUtils.showToast('Error', result.getError()[0].message, 'error');
            }
        });
        $A.enqueueAction(action);
    }
})