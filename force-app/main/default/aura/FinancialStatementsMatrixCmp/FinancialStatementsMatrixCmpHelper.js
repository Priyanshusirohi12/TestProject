({
    getStatements : function(cmp) {
        var accountId = cmp.get("v.accountId");
        var action = cmp.get("c.initStatements");
        var params = {"accountId":accountId};
        action.setParams(params);
        console.log ('getting statements for ', accountId);
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting statements', response.getReturnValue());
                    cmp.set ("v.financialStatements", response.getReturnValue());
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
    
    addStatement : function(cmp, event) {
        console.log ('add a new statement called...');
        var action = cmp.get("c.addFinancialStatement");
        var financialStatements = cmp.get("v.financialStatements");
        var params = {"financialStatements": financialStatements,
                      "accountId": cmp.get("v.accountId")};
        action.setParams(params);
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    cmp.set ("v.financialStatements", response.getReturnValue());
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
    
    populateRowLabels : function(cmp) {
        var rowLabels = [];
        rowLabels.push('');
        rowLabels.push('Type');
        rowLabels.push('Quality');
        rowLabels.push('Fiscal Year Ended');
        rowLabels.push('');
        rowLabels.push('Cash');
        rowLabels.push('Current Assets');
        rowLabels.push('Total Assets');
        rowLabels.push('Current Liabilities');
        rowLabels.push('Total Liabilities');
        rowLabels.push('Retained Earnings');
        rowLabels.push('Net Worth');
        rowLabels.push('Tangible Net Worth');
        rowLabels.push('Total LT Term Debt');
        rowLabels.push('CPLTD w/o Revolver');
        rowLabels.push('CPLTD w/ Revolver');
        rowLabels.push('');
        rowLabels.push('Revenue');
        rowLabels.push('Gross Profit');
        rowLabels.push('Net Income');
        rowLabels.push('Taxes');
        rowLabels.push('Interest Expense');
        rowLabels.push('Depreciation & Amort');
        rowLabels.push('EBITDA');
        rowLabels.push('Extraordinary Gain');
        rowLabels.push('Extraordinary Loss');
        rowLabels.push('Adjusted Net Income');
        rowLabels.push('');
        rowLabels.push('Debt Service Coverage');
        rowLabels.push('Fixed Charge Coverage');
        rowLabels.push('Current Ratio');
        rowLabels.push('Debt/TNW (Leverage)');
        
        cmp.set("v.rowLabels", rowLabels);
    },
    
    saveChanges : function (cmp, event, shouldNavigateBack){
        console.log ('saving values');
        var action = cmp.get("c.saveFinancialStatements");
        var financialStatements = cmp.get("v.financialStatements");
        var params = {"financialStatements": financialStatements,
                      "accountId": cmp.get("v.accountId")};
        action.setParams(params);
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    cmp.set ("v.financialStatements", response.getReturnValue());
                    
                    if (shouldNavigateBack)
                        this.navigateBackToAccountRecord(cmp);
                    
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
    
    navigateBackToAccountRecord : function (cmp) {
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        var accountId = cmp.get("v.accountId");
        
        // Check if we are in S1 or LEX. If not, sObjectEvent will be undefined
        if(sObjectEvent){
            sObjectEvent.setParams({
                "accountId": accountId,
            })
            
            sObjectEvent.fire();            
        } else {
            window.location.assign('/' + accountId);
        }      
    }
    
})