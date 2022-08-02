({
    handleSameAddress : function (cmp, event, helper) {
        if (cmp.find("sameAsCompanyAddress").get("v.checked")) {
            var equipment = cmp.get("v.equipment");
            var company = cmp.get("v.company");
            equipment.Location_Address__c = company.BillingStreet;
            equipment.Location_City__c = company.BillingCity;
            equipment.Location_State__c = company.BillingStateCode;
            equipment.Location_Zip__c = company.BillingPostalCode;
            cmp.set("v.equipment", equipment);
        }
    },
    
    setSeriesPicklist : function (cmp, event, helper) {
        var equipment = cmp.get("v.equipment");
        var picklists = cmp.get("v.picklists");
        helper.getPicklistVals(cmp, picklists.seriesPicklistMap, equipment.Make_Picklist__c, "seriesFieldId");
    },
    
    setModelEnginePicklist : function (cmp, event, helper) {
        var equipment = cmp.get("v.equipment");
        var picklists = cmp.get("v.picklists");
        helper.getPicklistVals(cmp, picklists.modelPicklistMap, equipment.Series_Picklist__c, "modelFieldId");
        helper.getPicklistVals(cmp, picklists.enginePicklistMap, equipment.Series_Picklist__c, "engineFieldId");
    }
})