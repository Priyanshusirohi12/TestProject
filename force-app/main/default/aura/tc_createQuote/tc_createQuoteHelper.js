/**
 * Created on 12/8/17.
 */
({
    initQuoteOptionSelections: function (cmp) {
        var action = cmp.get('c.initQuoteOptionSelections');
        var that = this;
        action.setCallback(this, function (result) {
            if (result.getState() === 'SUCCESS') {
                var opts = JSON.parse(result.getReturnValue());
                cmp.set('v.freqOptions', opts.paymentFreq);
                cmp.set('v.termOptions', opts.term);
                cmp.set('v.finTypeOptions', opts.finType);
                cmp.set('v.rateOptions', opts.rateOptions);
                cmp.set('v.numOfAdvPaymentsOptions', opts.numOfAdvPaymentsOptions);
                cmp.set('v.credRatingOptions', opts.credRatingOptions);
                cmp.set('v.defaultDescription', that.getDefaultDescription(cmp));
                //load initial calculations

                //that.calculateOptions(cmp);
            } else {
                alert('error initQuoteOptionSelections - ' + result.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    initDefaultQuoteOption: function (cmp) {
        var quoteOption = {};
        quoteOption.Finance_Amount__c = 125000.00;
        quoteOption.Interest_Rate__c = 3.125;
        quoteOption.Rate_Factor__c = 0.085600;
        quoteOption.Margin__c = 0;
        quoteOption.Balloon_Amount__c = 0;
        quoteOption.Include_in_Quote__c = false;


        cmp.set('v.quoteOption', quoteOption);


    },

    clearOptions : function (cmp) {
        cmp.set('v.quoteOptions', []);
    },

    getDefaultDescription : function (cmp) {
        var qo = cmp.get('v.quoteOption');
        var selectedRateOption = cmp.get('v.selectedRateOption');
        var descr = 'Option $' + qo.Finance_Amount__c + ' with ';

        if (selectedRateOption == 'credit')
            descr += cmp.get('v.selectedCreditRatingOption') + ' credit rating';

        else if (selectedRateOption == 'rate')
            descr += qo.Interest_Rate__c + ' interest rate';

        else if (selectedRateOption == 'rate_factor')
            descr += qo.Rate_Factor__c + ' rate factor';

        return descr;
    },

    calculateOptionsByCreditRating : function (cmp) {
        console.log('calculateOptionsByCreditRating');
        var quoteOption = cmp.get('v.quoteOption');
        this.showSpinner(cmp);
        var action = cmp.get('c.calculateQuoteOptionsByCreditRating');
        var selectedTermOptions = cmp.get('v.selectedTermOptions');
        var selectedCreditRatingOption = cmp.get('v.selectedCreditRatingOption');
        var that = this;


        action.setParams({
            quoteOption: quoteOption,
            terms: selectedTermOptions,
            creditRating: selectedCreditRatingOption
        });

        action.setCallback(this, function (result) {
            this.hideSpinner(cmp);
            var existingQuoteOptions = cmp.get('v.quoteOptions');

            if (result.getState() === 'SUCCESS') {
                var quoteOptions = result.getReturnValue();

                quoteOptions.forEach(function (el) {
                    console.log(el);
                    el.Credit_Rating__c = selectedCreditRatingOption;
                    if (!el.Quote_Option_Description__c)
                        el.Quote_Option_Description__c = that.getDefaultDescription(cmp);

                    el.Payment_Amount__c = el.Rate_Factor__c * el.Finance_Amount__c;
                    existingQuoteOptions.unshift(el);
                });

                var sortedOptions = existingQuoteOptions.slice(0,10);
                sortedOptions.sort(function (a, b) {
                    return a.Payment_Amount__c - b.Payment_Amount__c;
                });
                cmp.set('v.quoteOptions', sortedOptions);
            } else {
                alert('error calculateOptionsByCreditRating - ' + result.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    calculateQuoteOptionsByRateTerm : function (cmp) {
        console.log('calculateQuoteOptionsByRateTerm');
        var that = this;
        this.showSpinner(cmp);
        var action = cmp.get('c.calculateQuoteOptionsByRateTerm');
        var selectedTermOptions = cmp.get('v.selectedTermOptions');

        action.setParams({
            terms: selectedTermOptions,
            quoteOption: cmp.get('v.quoteOption')
        });

        action.setCallback(this, function (result) {
            this.hideSpinner(cmp);
            var existingQuoteOptions = cmp.get('v.quoteOptions');

            if (result.getState() === 'SUCCESS') {
                var quoteOptions = result.getReturnValue();
                console.log('calculateQuoteOptionsByRateTerm', quoteOptions);
                quoteOptions.forEach(function (el) {
                    if (!el.Quote_Option_Description__c)
                        el.Quote_Option_Description__c = that.getDefaultDescription(cmp);

                    existingQuoteOptions.unshift(el);
                });

                var sortedOptions = existingQuoteOptions.slice(0,10);
                sortedOptions.sort(function (a, b) {
                    return a.Payment_Amount__c - b.Payment_Amount__c;
                });
                cmp.set('v.quoteOptions', sortedOptions);
            } else {
                alert('error calculateQuoteOptionsByRateTerm - ' + result.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    calculateQuoteOptionsByRateFactor : function (cmp) {
        console.log('calculateQuoteOptionsByRateFactor');
        var that = this;
        this.showSpinner(cmp);
        var action = cmp.get('c.calculateQuoteOptionsByRateFactor');
        var selectedTermOptions = cmp.get('v.selectedTermOptions');

        action.setParams({
            terms: selectedTermOptions,
            quoteOption: cmp.get('v.quoteOption')
        });

        action.setCallback(this, function (result) {
            this.hideSpinner(cmp);
            var existingQuoteOptions = cmp.get('v.quoteOptions');

            if (result.getState() === 'SUCCESS') {
                var quoteOptions = result.getReturnValue();
                console.log('result', quoteOptions);
                quoteOptions.forEach(function (el) {
                    if (!el.Quote_Option_Description__c)
                        el.Quote_Option_Description__c = that.getDefaultDescription(cmp);

                    existingQuoteOptions.unshift(el);
                });
                var sortedOptions = existingQuoteOptions.slice(0,10);
                sortedOptions.sort(function (a, b) {
                    return a.Payment_Amount__c - b.Payment_Amount__c;
                });
                cmp.set('v.quoteOptions', sortedOptions);
            } else {
                alert('error calculateQuoteOptionsByRateTerm - ' + result.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    calculateOptions: function (cmp) {
        var qo = cmp.get('v.quoteOption');
        cmp.set('v.defaultDescription', this.getDefaultDescription(cmp));
        if (cmp.get('v.selectedRateOption') === 'credit') {
            this.calculateOptionsByCreditRating (cmp);
        } else if (cmp.get('v.selectedRateOption') === 'rate') {
            this.calculateQuoteOptionsByRateTerm (cmp);
        } else if (cmp.get('v.selectedRateOption') === 'rate_factor') {
            this.calculateQuoteOptionsByRateFactor (cmp);
        }

    },

    showSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    startLoanApplication: function (cmp, quoteOptions) {

        if (quoteOptions.length>0) {
            TCLightningUtils.showSpinner(cmp);
            var action = cmp.get('c.createLoanApplication');

            action.setParams({
                quoteOptionsString: JSON.stringify(quoteOptions)
            });

            action.setCallback(this, function (result) {
                TCLightningUtils.hideSpinner(cmp);
                console.log(result);
                if (result.getState() === 'SUCCESS') {

                    // var evt = $A.get("e.force:navigateToComponent");
                    // evt.setParams({
                    //     componentDef : "c:tc_loanApplication",
                    //     componentAttributes: {
                    //         application : {},
                    //         recordId : result.getReturnValue()
                    //     }
                    // });
                    // evt.fire();
                    if (result.getReturnValue()) {
                        console.log('sending to app...');
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": '/loan-application?id=' + result.getReturnValue()
                        });

                        urlEvent.fire();
                    } else {
                        console.log(result.getReturnValue());
                    }


                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.getError()[0].message,
                        "type": 'error'
                    });
                    toastEvent.fire();

                }
            });

            $A.enqueueAction(action);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select quote option to apply.",
                "type": 'error'
            });
            toastEvent.fire();
        }
    }

})