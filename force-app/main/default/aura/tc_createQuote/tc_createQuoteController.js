/**
 * Created on 12/8/17.
 */
({
    doInit: function (cmp, event, helper) {
        helper.initDefaultQuoteOption (cmp);
        helper.initQuoteOptionSelections(cmp);
    },

    handleApplyClick: function (cmp, event, helper) {
        console.log('handleApplyClick');
        helper.createLoanApp(cmp);
    },

    handleQuoteOptionsChanged : function (cmp, event, helper) {
        var options = event.getParam('value');
        console.log('handleQuoteOptionsChanged', options);

        var appEvent = $A.get("e.c:tc_quoteCalculations_evt");
        appEvent.setParams({
            data: {
                calculatedOptions: options,
                eventType: 'handle_options'
            }
        });
        appEvent.fire();
    },

    clearCalculator : function (cmp, event, helper) {
        helper.clearOptions (cmp);
    },

    calculateOptions : function (cmp, event, helper) {
        helper.calculateOptions (cmp);
    },

    handleQuoteCalculationsEvt : function (cmp, event, helper) {
        var data = event.getParam('data');
        var quoteOptions = data.calculatedOptions;
        if (data.eventType === 'start_application') {
            console.log('handleQuoteCalculationsEvt quoteOptions', quoteOptions);
            helper.startLoanApplication (cmp, quoteOptions);
        }
    },

    toggleInfoSection : function (cmp, event, helper) {
        cmp.set('v.showAdditionalInfo', !cmp.get('v.showAdditionalInfo'));
    },

    onDescriptionFocus : function (cmp, event, helper) {
        var qo = cmp.get('v.quoteOption');
        var inputField = event.getSource();
        var defaultDescription = helper.getDefaultDescription(cmp);

        if (!inputField.get('v.value')) {
            inputField.set('v.value', inputField.get('v.placeholder'));
            qo.Quote_Option_Description__c = defaultDescription;
        }
    }
})