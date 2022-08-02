({ 
	init : function(cmp, event, helper) {
	 	helper.grabWrapper(cmp, event, helper);
	},
    
    handlePrint : function(cmp, event, helper) {
        window.print();
    },
     
})