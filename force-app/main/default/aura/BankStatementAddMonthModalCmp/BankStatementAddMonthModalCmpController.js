({
    saveNewStatement : function(cmp, event, helper) {
        var month = cmp.get("v.month");
        var year = cmp.get("v.year");
        var todayDate = new Date();
        if (!month || !year || month>12 || month<1 || year < 1970 || year > todayDate.getFullYear()) {
           cmp.set("v.errorMsg", 'Please enter valid year and month values.');
           helper.showError (cmp); 
        } else {
            helper.addStatement(cmp);
        }
        
	},
    
    handleAddMonthEvent : function(component, event, helper) {
        helper.openModalDialog(component);
        component.set("v.bankInfoId", event.getParam("bankInfoId"));
	},
    
    closeModalDialog : function(component, event, helper) {
        helper.closeModalDialog(component);
	},
    
    closeAlert: function(cmp, event, helper) {
        helper.closeAlert(cmp);
    },  
})