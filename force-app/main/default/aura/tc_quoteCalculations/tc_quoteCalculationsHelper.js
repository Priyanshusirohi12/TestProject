/**
 * Created on 12/23/17.
 */
({
    createLoanApp: function (cmp, event, helper) {
        var options = cmp.get('v.quoteOptions');
        console.log('createLoanApp', options);

        var appEvent = $A.get("e.c:tc_quoteCalculations_evt");
        console.log('fire options event to start app', appEvent);
        appEvent.setParams({

            data: {
                eventType: 'start_application',
                calculatedOptions: options
            }
        });
        appEvent.fire();
    }
})