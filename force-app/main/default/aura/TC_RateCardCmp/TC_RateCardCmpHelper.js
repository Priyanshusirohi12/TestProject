({
     
    getRows : function(cmp) {
        console.log('cmp='+cmp);
        var rateCardId = cmp.get("v.rateCardId");
        var action = cmp.get("c.getRows");
        var params = {"rateCardId":rateCardId};
        action.setParams(params);
        console.log ('getting rows for [ '+ rateCardId + ']');
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting rows', response.getReturnValue());
                    cmp.set ("v.rateCardRows", response.getReturnValue());
                    
                    
                } else {
                    console.log ('Error : ' + state);
                    console.log (response.getError()[0].message);
                }
                
            }
            catch (e) {
                console.log('Exception ' + e);
            }
        });
        $A.enqueueAction(action); 
    },
    getColumns : function(cmp) {
        console.log('cmp='+cmp);
        var rateCardId = cmp.get("v.rateCardId");
        var action = cmp.get("c.getColumns");
        var params = {"rateCardId":rateCardId};
        action.setParams(params);
        console.log ('getting columns for [ '+ rateCardId + ']');
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting columns', response.getReturnValue());
                    cmp.set ("v.rateCardCols", response.getReturnValue());
                    
                    
                } else {
                    console.log ('Error : ' + state);
                    console.log (response.getError()[0].message);
                }
                
            }
            catch (e) {
                console.log('Exception ' + e);
            }
        });
        $A.enqueueAction(action); 
    },
    saveChanges : function (cmp, event, shouldNavigateBack){
        console.log ('saving rate card');

        var action = cmp.get("c.saveRateCardValues");
        console.log('action = ' + action);
        
        
        console.log(' here 0.1 ');
        
        var rateCardId = cmp.get("v.rateCardId");        
        var rateCardCols = cmp.get("v.rateCardCols");
        
        console.log(' here 0.2 ');
        var rateList = []; 
        console.log(' here 0.3 ');
        //populate transactions map
        for (var i=0; i<rateCardCols.length; i++) {
            console.log('loop 1')
            for (var j=0; j<rateCardCols[i].Rate_Card_Rates__r.length; j++) {
                console.log('loop 2');
                var rcr = rateCardCols[i].Rate_Card_Rates__r[j];
                console.log('rate = ' + rcr.Rate__c);
                rateList.push(rateCardCols[i].Rate_Card_Rates__r[j]);
            }
        }
        
        console.log('rateList = ' + rateList);
             

        var params = {"rateCardId":rateCardId,"rateList":rateList};
        console.log(' here 1 ');
   
        action.setParams(params);
        console.log(' here 2 ');

        action.setCallback(this, function(response) {
            
            console.log(' here 3 ');

            try {
                var state = response.getState();
                console.log(' here 4 ');
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log(' here 5 ');
                    
                    cmp.set ("v.rateCardCols", response.getReturnValue());
                    
                    if (shouldNavigateBack)
                        this.navigateBackToRateCard(cmp);
                    
                } else {
                    console.log(' here 6 ');
                    console.log ('Error : ' + state);
                    console.log (response.getError()[0].message);
                }
                
            }
            catch (e) {
                console.log('Exception ' + e);
            }
           
        });
        $A.enqueueAction(action);

    },
    
    navigateBackToRateCard : function (cmp) {
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        var rateCardId = cmp.get("v.rateCardId");
        // Check if we are in S1 or LEX. If not, sObjectEvent will be undefined
        if(sObjectEvent){
            
            sObjectEvent.setParams({
                "rateCardId": rateCardId,
            })
            
            sObjectEvent.fire();            
        } else {
            window.location.assign('/' + rateCardId);
        }      
    }
})