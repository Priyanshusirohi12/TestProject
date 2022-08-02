({
    doInit : function (cmp, event, helper) {
        helper.addEquipment(cmp);
        helper.getPicklists(cmp);
    },

    addEquipment: function (cmp, event, helper) {
        helper.addEquipment(cmp);
    },

    deleteItem : function (cmp, event, helper) {
        var equipmentList = cmp.get("v.equipmentList");

        var indexVal = event.getSource().get('v.value');

        equipmentList.pop(indexVal);
        console.log(equipmentList);
        cmp.set("v.equipmentList",equipmentList);
    },

    clearItem : function (cmp, event, helper) {
        var equipmentList = cmp.get("v.equipmentList");

        var indexVal = event.getSource().get('v.value');
        
        var equipment = {sobjectType: 'Equipment__c'};
        equipment.Name = 'Description';

        equipmentList[indexVal] = equipment;
        console.log(equipmentList);
        cmp.set("v.equipmentList",equipmentList);
    },

    quickSave : function (cmp, event, helper) {
        helper.quickSave(cmp, event, helper);
    },

    goToNext : function (cmp, event, helper) {
        var navEvent = $A.get("e.c:tc_applicationNavigation_evt");
        var dir = "next";
        
        navEvent.setParams({
            data: {
                direction: dir
            }
        });
        
        navEvent.fire();
    }
})