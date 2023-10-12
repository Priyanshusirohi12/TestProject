({
	doInit: function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        utilityAPI.getAllUtilityInfo().then(function (response) {
            if (typeof response !== 'undefined') {
                		console.log('response ',response);
                        utilityAPI.openUtility();
            }
        });
	},
    /*handleReceiveMessage: function (component, event, helper) {
                if (event != null) {
                    const message = event.getParam('messageText');
                    if(message != null){
                        var utilityAPI = component.find("utilitybar");
                        utilityAPI.getAllUtilityInfo().then(function (response) {
                            if (typeof response !== 'undefined') {
                                        utilityAPI.openUtility();
                            }
                        });
                    }
                    console.log('handleReceiveMessage ',message);
                    component.set("v.messageText", 'Message: ' + message );
                }
            },*/
    passDataToLWC : function(component, event, helper)
	{
		let stringToSend = component.find("dataToPass").get("v.value");
        component.find("childlwc").childFunction(stringToSend);
	},
    receiveLWCData : function(component, event, helper)
	{
        console.log('event is running ');
	    component.set("v.dataReceived", event.getParam("dataToSend"));
        //console.log('v.dataReceived ',v.dataReceived);
        
	},
    onTabCreated: function(cmp) {
        var workspace = cmp.find("workspace");
        var limit = cmp.get("v.limit");
        console.log('cgfs');
        workspace.getAllTabInfo().then(function (tabInfo) {
            console.log('cgfs 1');
            if (tabInfo.length > limit) {
                console.log('cgfs 2');
                workspace.closeTab({
                    tabId: tabInfo[0].tabId
                });
            }
        });
    }

})