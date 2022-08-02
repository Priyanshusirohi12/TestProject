({
    doInit : function (cmp, event) {
        cmp.set('v.equipment.Location_Country__c', 'US');
    },

    toggleAdditionalSection : function(cmp, event, helper) {

        var toggleBoolean = cmp.get('v.toggleAdditionalDetails');
        cmp.set('v.toggleAdditionalDetails', !toggleBoolean);

        var acc = cmp.find('additionalSection');
        for (var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');
            $A.util.toggleClass(acc[cmp], 'slds-hide');
        }
        
    },

    onStateChange : function (cmp, event) {

        cmp.set('v.equipment.Location_State__c', cmp.get('v.tempState'));
        var stateBoolean = cmp.get('v.stateBoolean');
        cmp.set('v.stateBoolean', !stateBoolean);

    },

})