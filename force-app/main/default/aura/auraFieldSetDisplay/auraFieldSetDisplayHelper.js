({
    initialize : function(component, event, helper) {
        var sObjectName = component.get('v.sObjectName');
        sObjectName = $A.util.isEmpty(sObjectName) ? component.get('v.objType') : sObjectName;
        var fieldSetName = component.get('v.fieldSetName');
        var navEvt = $A.get('e.tc_qq:MassUpdate');
        console.log('navevt MassUpdate:');
        console.log(navEvt);
        if (!$A.util.isEmpty(sObjectName) && !$A.util.isEmpty(fieldSetName)) {
            var apexCall = component.get('c.getFieldsFromFieldSet');
            var params = new Object();
            params.objectName = sObjectName;
            params.fieldSetName = fieldSetName;
            apexCall.setParams(params);

            apexCall.setCallback(this, function(response) {
                var state = response.getState();

                if (state === 'SUCCESS') {
                    var fsDisplayResult = response.getReturnValue();
                    if (!$A.util.isEmpty(fsDisplayResult) && $A.util.isObject(fsDisplayResult)) {
                        var errors = fsDisplayResult.errors;

                        if (!$A.util.isEmpty(errors)) {
                            var errorsConcat = '';
                            for (var i = 0, error; error=errors[i]; i++) {
                                if (i != 0) errorsConcat+=';';
                                errorsConcat+=error.message;
                            }
                            console.log('Errors from apex controller:'+errorsConcat);
                            this.errorToast(errorsConcat);
                        } else {
                            var fields = fsDisplayResult.fields;
                            if (!$A.util.isEmpty(fields) && $A.util.isArray(fields)) {
                                component.set('v.fields',fields);
                            }
                            if (!$A.util.isEmpty(fsDisplayResult.objectName)) {
                                component.set('v.sObjectName',fsDisplayResult.objectName);
                            }
                            console.log('fsDisplayResult.recordId:'+fsDisplayResult.recordId);
                            if (!$A.util.isEmpty(fsDisplayResult.recordId)) {
                                component.set('v.recordId',fsDisplayResult.recordId);
                            }
                        }
                    }

                } else {
                    console.log('Apex call failed! Code:'+state);
                    this.errorToast('Apex call failed! Code:'+state);
                }
            });
            $A.enqueueAction(apexCall);
        }
    },

    errorToast: function(errorMsg) {
        if (!$A.util.isEmpty(errorMsg)) {
            var resultsToast = $A.get("e.force:showToast");
            if ($A.util.isUndefined(resultsToast)) {
                alert(errorMsg);
            }else {
                resultsToast.setParams({
                    "title": "Error",
                    "message": errorMsg
                });
                resultsToast.fire();
            }
        }
    }
})