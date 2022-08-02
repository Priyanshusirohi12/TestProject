({
	doInit : function(component, event, helper) {
		//init
	},
    
	validateDate : function(component, event, helper) {
        console.log ('validateDate ... ');
        helper.validateDate(component);
	},
    
	closeAlert : function(component, event, helper) {
        console.log ('closeAlert ... ');
        helper.closeAlert(component);
	}
})