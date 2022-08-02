({

    addEquipmentHelper : function(cmp) {

        var equipmentList = cmp.get('v.wrapper.equipmentList');

        var equipment = {};
        equipment.sobjectType = 'Equipment__c';
        equipment.Name = '';
        equipment.Quantity__c = '';
        equipment.Cost_Per_Unit__c = '';

        equipmentList.push(equipment);
        cmp.set("v.wrapper.equipmentList", equipmentList);

    },

    clearEquipmentHelper : function (cmp, event) {

        var equipmentList = cmp.get('v.wrapper.equipmentList');
        var indexVal = event.getSource().get('v.value');

        var equipment = {};
        equipment.sobjectType = 'Equipment__c';
        equipment.Name = '';
        equipment.Quantity__c = '';
        equipment.Cost_Per_Unit__c = '';

        equipmentList[indexVal] = equipment;
        cmp.set('v.wrapper.equipmentList', equipmentList);

    },

    deleteEquipmentHelper : function (cmp, event) {

        var equipmentList = cmp.get('v.wrapper.equipmentList');
        var indexVal = event.getSource().get('v.value');

        equipmentList.splice(indexVal, 1);
        cmp.set('v.wrapper.equipmentList',equipmentList);

    },

    checkRequired : function (cmp) {

        var requiredFields = ['Name', 'Quantity__c', 'Cost_Per_Unit__c'];

        var equipmentList = cmp.get('v.wrapper.equipmentList');
        var equipmentValid = true;

        equipmentList.forEach(function (eItem, eIndex) {
            requiredFields.forEach(function (fItem, fIndex) {
                var value = equipmentList[eIndex][fItem];
                var boolean = !(value == undefined || value == '') ? true : false;
                equipmentValid = equipmentValid && boolean;
            });
        });

        if (!equipmentValid) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'Error',
                'type': 'error',
                'message': 'Please fill out the missing required fields in Equipment'
            });
            toastEvent.fire();
        }

        return equipmentValid;
    },

    saveAndPreviousHelper : function (cmp, event, helper) {
        var checkBoolean = this.checkRequired(cmp);
        if (checkBoolean) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'previous'
            });
            navigateEvent.fire();
        }
    },

    saveAndNextHelper : function (cmp, event, helper) {
        var checkBoolean = this.checkRequired(cmp);
        if (checkBoolean) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'next'
            });
            navigateEvent.fire();
        }
    },

    reviewAndSaveHelper : function (cmp, event, helper) {
        var checkBoolean = this.checkRequired(cmp);
        if (checkBoolean) {
            var navigateEvent = cmp.getEvent("changeTab");
            navigateEvent.setParams({
                'tabDirection' : 'submit'
            });
            navigateEvent.fire();
        }
    },

    clearAllEventHelper : function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": cmp.get('v.wrapper.cancelButtonURL')
        });
        urlEvent.fire();
    }

})