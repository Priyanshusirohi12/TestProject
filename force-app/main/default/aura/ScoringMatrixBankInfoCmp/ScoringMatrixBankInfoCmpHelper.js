({
    getStatements : function(cmp) {
        var bankInfoId = cmp.get("v.bankInfoId");
        var action = cmp.get("c.initStatements");
        var params = {"bankInfoId":bankInfoId};
        action.setParams(params);
        console.log ('getting statements for ', bankInfoId);
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting statements', response.getReturnValue());
                    cmp.set ("v.bankStatements", response.getReturnValue());
                    
                    
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
        var bankInfoId = cmp.get("v.bankInfoId");
        var addMonthEvent = $A.get("e.c:BankStatementAddMonthEvent");
        addMonthEvent.setParams({"bankInfoId": bankInfoId });
        addMonthEvent.fire();
    },
    
    populateDayLabels : function(cmp) {
        var dayLabels = [];
        dayLabels.push('');
        dayLabels.push('Ending Balance');
        dayLabels.push('Deposits');
        dayLabels.push('Negative Days');
        dayLabels.push('NSF/OD');
        dayLabels.push('Deposit Count');
        dayLabels.push('Unusual Deposits');
        dayLabels.push('Avg Daily Balance');
        
        
        for (var i=1; i<=31; i++) {
            dayLabels.push('Day ' + i);
        }
        cmp.set("v.dayLabels", dayLabels);
    },
    
    saveChanges : function (cmp, event, shouldNavigateBack){
        console.log ('saving values');
        var action = cmp.get("c.saveBankSatements");
        var bankStatements = cmp.get("v.bankStatements");
        var transactionsList = []; 
        
        //populate transactions map
        for (var i=0; i<bankStatements.length; i++) {
            for (var j=0; j<bankStatements[i].Bank_Statement_Transactions__r.length; j++) {
                var tr = bankStatements[i].Bank_Statement_Transactions__r[j];
                transactionsList.push(tr);
            }
        }
        
        var params = {"bankStatements":bankStatements,
                      "bankInfoId": cmp.get("v.bankInfoId"),
                      "transactions": transactionsList};
        action.setParams(params);
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    
                    cmp.set ("v.bankStatements", response.getReturnValue());
                    
                    if (shouldNavigateBack)
                        this.navigateBackToBankStatementRecord(cmp);
                    
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
    
    navigateBackToBankStatementRecord : function (cmp) {
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        var bankInfoId = cmp.get("v.bankInfoId");
        // Check if we are in S1 or LEX. If not, sObjectEvent will be undefined
        if(sObjectEvent){
            
            sObjectEvent.setParams({
                "bankInfoId": bankInfoId,
            })
            
            sObjectEvent.fire();            
        } else {
            window.location.assign('/' + bankInfoId);
        }      
    }
    
})