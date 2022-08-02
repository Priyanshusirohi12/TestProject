({

    getPermission : function(cmp) {

        var action = cmp.get("c.getObjectPermission");
        var params = {};
        action.setParams(params);
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting permission', response.getReturnValue());

                    var permission =  JSON.parse(response.getReturnValue());
                    cmp.set ("v.hasPermission", permission);


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

        var sobjectType = cmp.get("v.sobjectType");
        var fieldList = cmp.get("v.fieldList");
        var action = cmp.get("c.getColumnData");
        var params = {"sobjectType":sobjectType,"fieldList":fieldList};
        action.setParams(params);
        console.log ('getting columns data for [ '+ sobjectType + ']');
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting column data', response.getReturnValue());

                    var columns =  JSON.parse(response.getReturnValue());
                    console.table(columns);
                    cmp.set ("v.columns", columns);


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

    getRelatedList : function(cmp) {

        var recordId = cmp.get("v.recordId");
        var sobjectType = cmp.get("v.sobjectType");
        var action = cmp.get("c.getRelatedRecords");
        var params = {"parentId":recordId,"sobjectType":sobjectType};
        action.setParams(params);
        console.log ('getting realted records for [ '+ recordId + ']');
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting records', response.getReturnValue());
                    cmp.set ("v.data", response.getReturnValue());


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


    getIcon : function(cmp) {
        var sobjectType = cmp.get("v.sobjectType");
        var recordId = cmp.get("v.recordId");
        var action = cmp.get("c.getIconName");
        var params = {"parentId":recordId,"sobjectType":sobjectType};
        action.setParams(params);
        console.log ('getting icon name for [ '+ sobjectType + ']');
        action.setCallback(this, function(response) {
            try {
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting icon', response.getReturnValue());
                    cmp.set ("v.icon", response.getReturnValue());


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

})