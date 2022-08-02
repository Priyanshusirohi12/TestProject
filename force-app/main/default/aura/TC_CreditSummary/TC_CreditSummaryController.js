({
    doInit: function (cmp, event, helper) {
        var action = cmp.get('c.initData');
        var params = {"oppId": cmp.get('v.recordId')};
        action.setParams(params);

        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = JSON.parse(response.getReturnValue());

            if (cmp.isValid() && state === "SUCCESS") {
                cmp.set('v.opportunity', data.opportunity);
                cmp.set("v.oppFields", data.oppFieldsSet);
                cmp.set("v.decisionFieldsSet", data.decisionFieldsSet);
                cmp.set('v.creditLenderFieldsSet', data.creditLenderFieldsSet);

                cmp.set("v.borrowerId", data.opportunity.AccountId);
                cmp.set("v.borrowerFields", data.borrowerFieldsSet);

                cmp.set("v.vendors", data.vendors);
                cmp.set("v.vendorFieldsSet", data.vendorFieldsSet);

                cmp.set("v.equipment", data.equipment);
                cmp.set("v.assetFieldsSet", data.assetFieldsSet);

                cmp.set("v.settings", data.settings);

                cmp.set('v.paynetId', data.paynetId);
                cmp.set('v.paynetFieldsSet', data.paynetFieldsSet);

                cmp.set('v.dnbId', data.dnbId);
                cmp.set('v.dnbFieldsSet', data.dnbFieldsSet);

                cmp.set('v.scorecardId', data.scorecardId);
                cmp.set('v.scorecardFieldsSet', data.scorecardFieldsSet);

                cmp.set("v.guarantors", data.guarantors);
                cmp.set("v.guarContactFieldsSet", data.guarContactFieldsSet);
                cmp.set('v.guarReportFieldsSet', data.guarReportFieldsSet);

                var guarReportFieldsSetExists = data.guarReportFieldsSet.length > 0;
                var guarReportFieldsSetNeeded = false;
                data.guarantors.forEach(function(item, index) {
                    guarReportFieldsSetNeeded = guarReportFieldsSetNeeded || item.bureauReportId;
                });
                cmp.set('v.displayReportFieldsSet', guarReportFieldsSetExists && guarReportFieldsSetNeeded);

            } else {
                console.log('Error : ' + state);
                console.log(response.getError()[0].message);
            }
            
        });
        $A.enqueueAction(action);
    },

    printView: function (cmp, event, helper) {
        /* For Visualforce Page:
        var url = '/apex/TC_CreditSummaryPage?id=' + cmp.get('v.recordId');
        */
        var windowLocation = window.location.href;
        var sIndex = windowLocation.search('/s/');
        var windowLocationTrimmed = windowLocation.substring(0, sIndex);
        var url = windowLocationTrimmed + '/c/creditSummaryApp.app?oppId=' + cmp.get('v.recordId');
        var win = window.open(url, '_blank');
        win.focus();
    },

    printSummary: function (cmp, event, helper) {
        window.print();
    },

    savePrefenence: function (cmp, event, helper) {
        console.log('saveSettings');

        var action = cmp.get('c.updateSetting');
        var params = {"settingJson": JSON.stringify(cmp.get('v.settings'))};
        action.setParams(params);

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (cmp.isValid() && state === "SUCCESS") {
                console.log('done updateSetting', response.getReturnValue());
            } else {
                console.log('Error : ' + state);
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);

    },


})