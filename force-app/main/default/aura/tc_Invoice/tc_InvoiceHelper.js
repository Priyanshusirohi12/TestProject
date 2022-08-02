({
	grabWrapper : function(cmp, event, helper) {
 
		var action = cmp.get('c.grabInvoiceWrapper');
        action.setParams({
            recordId: cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(result) {
            if (result.getState() === "SUCCESS") {
                var returnedValue = result.getReturnValue();
                console.log(returnedValue);
                cmp.set('v.wrapper', returnedValue);
                cmp.set('v.invoiceNumber', returnedValue.invoiceNumber);
            } else {
                var error = result.getError();
                if (error && Array.isArray(error) && error.length > 0) {
                    var errorData = JSON.parse(error[0].message).message;
                    /*var toastParams = {
                        title: "Error",
                        message: errorData,
                        type: "error"
                    };
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams(toastParams);
                    toastEvent.fire();*/
                    alert('ERROR: ' + errorData + ' Invoice cannot be generated.');
                }           
            }
        });
        
        $A.enqueueAction(action);
	},
    
    handlePrintHelper : function(cmp, event, helper) {
    	var action = cmp.get('c.updateOpportunity');
        console.log(cmp.get("v.recordId") + ' and ' + cmp.get('v.wrapper.invoicenumber'));
        action.setParams({
            recordId: cmp.get("v.recordId"),
            invoiceNum: cmp.get("v.invoiceNumber")
        });
        
        action.setCallback(this, function(result) {
            if (result.getState() === "SUCCESS") {
                window.print();
            } else {
               /* var errorData = result.getError()[0].message;
                var toastParams = {
                    title: "Error",
                    message: errorData,
                    type: "error"
                };
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();*/
                alert('ERROR: ' + result.getError()[0].message);
            }
            
        });
        
        $A.enqueueAction(action);
	}

})