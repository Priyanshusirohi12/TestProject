({
	doInit : function(component, event, helper){ 
        //console.log('value of account '+JSON.stringify(component.get("v.accountifyId"))); 
		console.log('record Id ',JSON.stringify(component.get("v.AccountrecordId")));
	},
    
    handleSubmit : function(cmp, event, helper) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.getParam('fields');
        fields.LastName = 'My Custom Last Name'; // modify a field
        cmp.find('myRecordForm').submit(fields);
    }

})