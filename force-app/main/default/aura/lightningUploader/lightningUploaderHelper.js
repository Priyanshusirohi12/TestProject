({
    doInit : function(cmp) {
        console.log('initPage');
        var action = cmp.get('c.initPage');
        
        action.setCallback(this,function (result) {
            
            if (result.getState() === 'SUCCESS'){
                cmp.set('v.guestUserId', result.getReturnValue());
                
                
                
            } else {
                console.log('error', result.getError()[0].message);
            }
        });
        
        $A.enqueueAction (action);
    },
    
    showSpinner : function (cmp) {
        var indicator = cmp.find('spinner');
        if (indicator.isValid()) {
            $A.util.removeClass(indicator, 'slds-hide');
        }
        
    },
    
    hideSpinner : function (cmp) {
        var indicator = cmp.find('spinner');
        if (indicator) {
            $A.util.addClass(indicator, 'slds-hide');
        }
    }
    
})