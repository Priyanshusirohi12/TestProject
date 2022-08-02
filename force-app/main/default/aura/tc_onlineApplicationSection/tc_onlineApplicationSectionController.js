/**
 * Created by szheng on 2/10/20.
 */

({
    doInit: function(cmp, event, helper) {

        var countryStatesMap = cmp.get ('v.sectionWrapper.countryStatesMap');
        var countryPicklist = cmp.get ('v.sectionWrapper.countryCodeList');
        var originalCountryCode = cmp.get('v.sectionWrapper.sObjectRecord.CountryCode');
        if (originalCountryCode == undefined || originalCountryCode == null) {
            originalCountryCode = 'US';
            cmp.set('v.sectionWrapper.sObjectRecord.CountryCode', originalCountryCode);
        }
        cmp.set('v.stateCodes', countryStatesMap[originalCountryCode]);

    },

    /*stateCodeOnSelect : function(cmp, event, helper) {

         console.log('sectionWrapper.stateCode: ' + cmp.get('v.sectionWrapper.sObjectRecord.StateCode'));
         console.log('inputCmp: ' + cmp.find('statePicklist').get('v.value'));

	},*/

    countryCodeOnSelect : function(cmp, event, helper) {

         var countryStatesMap = cmp.get ('v.sectionWrapper.countryStatesMap');
         var originalCountryCode = cmp.get('v.sectionWrapper.sObjectRecord.CountryCode');
         cmp.set('v.stateCodes', countryStatesMap[originalCountryCode]);
         cmp.set('v.sectionWrapper.sObjectRecord.StateCode', '');

	},

    changeOnLookup : function(cmp, event, helper) {

        // Validate tempCountryCode to update statePicklist & countryPicklist
        var tempCountryCode = cmp.get('v.tempCountryCode');
        var countryStatesMap = cmp.get ('v.sectionWrapper.countryStatesMap');
        if (!countryStatesMap.hasOwnProperty(tempCountryCode)) {
            if (tempCountryCode == 'USA') tempCountryCode = 'US';
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Error",
                    "message" : '\'' + tempCountryCode + '\' is not a valid country option.',
                    "type" : "error"
                });
                toastEvent.fire();
            }
        }
        cmp.set('v.sectionWrapper.sObjectRecord.CountryCode', tempCountryCode);
        cmp.set('v.stateCodes', countryStatesMap[tempCountryCode]);
        cmp.set('v.addressUpdateBoolean', !cmp.get('v.addressUpdateBoolean'));

        // Update help messages if any inputs were initially invalid
        cmp.find('required').forEach(function (inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
        });

    },

    fieldValidation : function(cmp, event, helper) {

        var fieldSectionsValid = true;
        var addressSectionsValid = true;
        try{
            var inputComponent = cmp.find('AuraFieldSectionDisplay');
            if (!$A.util.isEmpty(inputComponent)) {
                if ($A.util.isArray(inputComponent)) {
                    fieldSectionsValid = inputComponent.reduce(function (validSoFar, inputCmp) {
                        fieldSectionsValid = validSoFar && inputCmp.validateFields();
                    }, true);
                } else {
                    fieldSectionsValid = inputComponent.validateFields();
                }

            }

            if (cmp.get('v.sectionWrapper.addressBoolean')) {
                var addressCmpList = cmp.find('required');
                addressSectionsValid = addressCmpList.reduce(function (validSoFar, inputCmp) {
                    inputCmp.showHelpMessageIfInvalid();
                    return validSoFar && inputCmp.get('v.validity').valid;
                }, true);
                // For some reason, StateCode does not bind to statePicklist input component **when selected**
                if (cmp.get('v.sectionWrapper.sObjectRecord.StateCode') == '') {
                    cmp.find('statePicklist').showHelpMessageIfInvalid();
                    addressSectionsValid = false;
                }
            }
        } catch (e) {
            console.log(e);
        }
        return fieldSectionsValid && addressSectionsValid;

    },

});