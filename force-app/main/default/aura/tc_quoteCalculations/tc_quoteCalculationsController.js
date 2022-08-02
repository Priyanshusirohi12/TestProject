/**
 * Created on 12/19/17.
 */
({
    handleOptionsCalculated: function (cmp, event, helper) {
        var data = event.getParam('data');

        if (data.eventType === 'handle_options') {
            cmp.set('v.quoteOptions', event.getParam('data').calculatedOptions);
        }
    },

    startApplication: function (cmp, event, helper) {
        var button = event.getSource();
        var quoteOption = button.get('v.value');
        quoteOption.Include_in_Quote__c = true;
        button.set('v.value', quoteOption);
        helper.createLoanApp(cmp, event, helper);
    },

    viewDetails: function (cmp, event, helper) {

        var button = event.getSource();
        var quoteOption = button.get('v.value');

        var modalBody;

        $A.createComponent("c:tc_quoteOptionDetail", {
            quoteOption : quoteOption
            },
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    cmp.find('overlayLib').showCustomModal({
                        header: "Quote Option Details",
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: "quoteOptionDetail",
                        closeCallback: function () {
                            //alert('You closed the alert!');
                        }
                    });
                }

            });
    }
})