({
	getOppAndAccountNames : function(component) {
        
		// the function that reads the url parameters
            var getUrlParameter = function getUrlParameter(sParam) {
                var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                    sURLVariables = sPageURL.split('&'),
                    sParameterName,
                    i;

                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('=');

                    if (sParameterName[0] === sParam) {
                        return sParameterName[1] === undefined ? true : sParameterName[1];
                    }
                }
            };

            //set the src param value to my src attribute
            var appNum = getUrlParameter('appNum');
        
        var action = component.get('c.getOpportunityAndAccountName');
        
        action.setParams({ appNum : appNum });

		
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log (response.getReturnValue());
                component.set('v.heading', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);

	}
})