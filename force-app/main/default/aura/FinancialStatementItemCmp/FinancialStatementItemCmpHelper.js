({
	validateDate : function(cmp) {
        console.log ('helper validateDate ... ');
        var inputDate = cmp.find("fiscalYearEndedDate");
        var value = inputDate.get("v.value");
        var dateRegex = /^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$/;
        
        if (!(dateRegex.test(value)) || isNaN(Date.parse(value))) {
            cmp.set("v.errorMsg", value + " is not a valid date.  Please enter date in MM/DD/YYYY format.");
            this.showError(cmp);
            inputDate.set("v.value", "");
        }
	},
    
    showError : function(cmp) {
        console.log ('helper showError ... ');
        var alertMsgPanel = cmp.find("alertMsgPanel");
        $A.util.addClass(alertMsgPanel, "slds-visible");
        $A.util.removeClass(alertMsgPanel, "slds-hidden");
    },
    
    closeAlert: function(cmp) {
        var alertMsgPanel = cmp.find("alertMsgPanel");
        $A.util.removeClass(alertMsgPanel, "slds-visible");
        $A.util.addClass(alertMsgPanel, "slds-hidden");
    }
})