({
    doInit : function (component, event, helper) {
        var field = component.get('v.field');
        if (field.isBoolean) {
            // For some reason, field.fieldValues for Boolean fields are not treated as Booleans in the component
            if (field.fieldValue == true) component.set('v.field.fieldValue', true);
            else component.set('v.field.fieldValue', false);
        }
        //console.log('field: ' + JSON.stringify(field));
    },
    doChange : function (component, event, helper) {
        var sobj = component.get('v.sObject');
        var field = component.get('v.field');
        sobj[field.fieldName] = field.fieldValue;
        component.set('v.sObject',sobj);
    },
    doValidateField: function (component, event, helper) {
        var allValid = true;
        var fieldDisplay = component.find('aura_field_display_input');
        if (!$A.util.isEmpty(fieldDisplay)) {
            if ($A.util.isArray(fieldDisplay)) {
                allValid = fieldDisplay.reduce(function (validSoFar, inputcomponent) {
                    inputcomponent.showHelpMessageIfInvalid();
                    if (!$A.util.isEmpty(inputcomponent.checkValidity())) return validSoFar && inputcomponent.checkValidity();
                    else return validSoFar;
                }, true);
            } else {
                fieldDisplay.showHelpMessageIfInvalid();
                allValid = fieldDisplay.checkValidity();
            }
        }

        return allValid;
    },
});