({
    doInit : function(cmp, event, helper) {
        console.log ('doInit ... ');
        helper.getStatements(cmp);
        helper.populateDayLabels(cmp);
    },
    
    handleRefreshData : function(cmp, event, helper) {
        console.log ('handleRefreshData ... ');
        helper.getStatements(cmp);
    },
    
    waiting : function(cmp, event, helper) {
        
        var spnr = cmp.find("spinner");
        $A.util.removeClass(spnr, "slds-hidden");
        $A.util.addClass(spnr, "slds-visible");
        
    },
    
    doneWaiting : function(cmp, event, helper) {
        
        var spnr = cmp.find("spinner");
        $A.util.removeClass(spnr, "slds-visible");
        $A.util.addClass(spnr, "slds-hidden");
    },
    
    closeAlert: function(cmp, event, helper) {
        
        var alertMsgPanel = cmp.find("alertMsgPanel");
        $A.util.removeClass(alertMsgPanel, "slds-visible");
        $A.util.addClass(alertMsgPanel, "slds-hidden");
        
    },
    
    saveStatements : function(cmp, event, helper) {
        
        helper.saveChanges (cmp, event, false);
    },
    
    addStatement: function (cmp, event, helper) { 
        helper.addStatement (cmp, event);
    }, 
    
    saveStatementsAndClose : function(cmp, event, helper) {
        
        helper.saveChanges (cmp, event, true);
    },
    
    cancelAndClose : function(cmp, event, helper) {
        helper.navigateBackToBankStatementRecord (cmp);
    },
    
})