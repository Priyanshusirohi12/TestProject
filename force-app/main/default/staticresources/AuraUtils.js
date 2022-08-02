// AuraUtils

/*
 * Promises support for Aura framework
 */
(function (w) {


    /*
     * Remote call promise wrapper
    */
    let _executeServerSideAction = function (cmp, action, callback) {
        console.log('_executeServerSideAction', action.getName());
        return new Promise(function (resolve, reject) {
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let retVal = response.getReturnValue();
                    resolve(retVal);
                }
                else if (state === "ERROR") {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            });
            $A.enqueueAction(action);
        });
    }

    let _showToast = function (title, message, messageType, mode) {

        /*
        The toast mode, which controls how users can dismiss the toast. The default is dismissible, which displays the close button.
            Valid values:
            dismissible: Remains visible until you press the close button or duration has elapsed, whichever comes first.
            pester: Remains visible until duration has elapsed. No close button is displayed.
            sticky: Remains visible until you press the close buttons.

        */

        //try S1 app first
        //in case we are in one.app'

        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": messageType,
                mode: mode ? mode :'dismissible'
            });
            toastEvent.fire();
            toastEvent = null;
        }
    }

    let _showSpinner = function (cmp) {
        let indicator = cmp.find('spinner');
        if (indicator.isValid()) {
            $A.util.removeClass(indicator, 'slds-hide');
        }

    }

    let _hideSpinner = function (cmp) {
        let indicator = cmp.find('spinner');
        if (indicator) {
            $A.util.addClass(indicator, 'slds-hide');
        }
    }

    // export module returns
    w.TCLightningUtils = {
        showToast: _showToast,
        executeServerSideAction: _executeServerSideAction,
        showSpinner : _showSpinner,
        hideSpinner : _hideSpinner
    }
})(window);