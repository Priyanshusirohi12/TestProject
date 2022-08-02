/**
 * Created on 12/30/17.
 */
({
    doInit : function (cmp, event, helper) {
        var deal = cmp.get('v.deal');
        if ( deal && deal.Id) {
            helper.getQuoteOptions(cmp);
        }
        
        cmp.set('v.masterLineId', deal.Related_Master_Line__c);
        
        if (cmp.get('v.masterLineId'))
            helper.setMasterLine(cmp);
    },

    goToEquipmentDetails : function (cmp, event, helper) {
        var navEvent = $A.get("e.c:tc_applicationNavigation_evt");
        var dir = "prev";
        
        navEvent.setParams({
            data: {
                direction: dir
            }
        });
        
        navEvent.fire();
    },
    
    clearDeal : function (cmp, event, helper) {
        var deal = cmp.get("v.deal");
        deal.Loan_Purpose__c = '';
        cmp.set("v.deal", deal);
    },

    quickSave : function (cmp, event, helper) {
        helper.quickSave(cmp, event, helper);
    },
    
    
    updateSelected: function(cmp, evt) {
        var selected = evt.getSource().get("v.text");
        var quoteOptions = cmp.get("v.quoteOptions");
        
        for (var i = 0; i < quoteOptions.length; i++) {
            var qo = quoteOptions[i];
            qo.Include_in_Quote__c = (qo.Id == selected);
        }
        
        cmp.set('v.quoteOptions', quoteOptions);
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