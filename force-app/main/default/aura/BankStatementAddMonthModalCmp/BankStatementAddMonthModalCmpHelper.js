({
    addStatement : function(cmp) {
        console.log ('Adding statement...');
        var bankInfoId = cmp.get("v.bankInfoId");
        var month = cmp.get("v.month");
        var year = cmp.get("v.year");
        var action = cmp.get("c.addBankStatement");console.log ('Adding statement...' + bankInfoId);
        var params = {"bankInfoId":bankInfoId, "statementYear":year.toString(), "statementMonth":month.toString()};
        
        action.setParams(params);
        action.setCallback(this, function(response) {
            try {
                this.closeAlert (cmp);
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done adding statements');
                    var refreshStatementsEvent = $A.get("e.c:BankStatementRefreshRecords");
                    
                    refreshStatementsEvent.fire(); 
                    this.closeModalDialog(cmp);
                } else {
                    console.log ('Error : ' + state);
                    
                    console.log (response.getError()[0].message);
                    cmp.set("v.errorMsg", response.getError()[0].message);
                    this.showError (cmp);
                }
                
            }
            catch (e) {
                cmp.set("v.errorMsg", e);
                this.showError (cmp);
                console.log('Exception ' + e);
            }
        });
        $A.enqueueAction(action); 
    },
    
    openModalDialog : function(component) {
        console.log ('Opening modal to add month');
        var dialogPanel = component.find("dialogPanel");
        var backdropPanel = component.find("backdropPanel");
        $A.util.addClass(backdropPanel, "slds-backdrop--open");
        $A.util.addClass(dialogPanel, "slds-fade-in-open");
    },
    
    closeModalDialog : function(component) {
        console.log ('Closing modal to add month');
        var dialogPanel = component.find("dialogPanel");
        var backdropPanel = component.find("backdropPanel");
        $A.util.removeClass(backdropPanel, "slds-backdrop--open");
        $A.util.removeClass(dialogPanel, "slds-fade-in-open");
    },
    
    
     showError : function(cmp) {
        var alertMsgPanel = cmp.find("alertMsgPanel");
        $A.util.addClass(alertMsgPanel, "slds-visible");
        $A.util.removeClass(alertMsgPanel, "slds-hidden");
    },
    
    closeAlert: function(cmp) {
        var alertMsgPanel = cmp.find("alertMsgPanel");
        $A.util.removeClass(alertMsgPanel, "slds-visible");
        $A.util.addClass(alertMsgPanel, "slds-hidden");
    },
   
})