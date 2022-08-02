({
  
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
    },
    
    getOpps : function(cmp) {
        var objId = cmp.get("v.objId");
        var action = cmp.get("c.getOpportunities");
        var params = {"objId":objId};
        action.setParams(params);
        console.log ('getting opportunity for ', objId);
        this.showSpinner(cmp);
        action.setCallback(this, function(response) {
            try {
                this.hideSpinner(cmp);
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting opportunities', response.getReturnValue());
                    cmp.set ("v.opportunities", response.getReturnValue());
                    
                } else {
                    console.log ('Error : ' + state);
                    console.log (response.getError()[0].message);
                    cmp.set("v.fatalError", true);
                }
                
            }
            catch (e) {
                console.log('Exception ' + e);
                cmp.set("v.fatalError", true);
            }
        });
        $A.enqueueAction(action); 
    },        
    getFiles : function(cmp) {
        var objId = cmp.get("v.objId");
        var action = cmp.get("c.getContent");
        var params = {"objId":objId};
        action.setParams(params);
        console.log ('getting content for ', objId);
        this.showSpinner(cmp);
        action.setCallback(this, function(response) {
            try {
                this.hideSpinner(cmp);
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                    console.log ('done getting content', response.getReturnValue());
                    cmp.set ("v.fileList", response.getReturnValue());
                    
                    
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
    delFiles : function(cmp, fileIds) {
        var objId = cmp.get("v.objId");
        var action = cmp.get("c.markDeleteFiles");
        var params = {"objId":objId,"fileIds":fileIds};
        action.setParams(params);
        console.log ('deleting file ', fileIds);
        this.showSpinner(cmp);
        action.setCallback(this, function(response) {
            try {
                this.hideSpinner(cmp);
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                      console.log ('done marking delete files', response.getReturnValue());                  
                      cmp.set ("v.fileList", response.getReturnValue());
                    
                    
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
    undelFiles : function(cmp, fileIds) {
        var objId = cmp.get("v.objId");
        var action = cmp.get("c.unmarkDeleteFiles");
        var params = {"objId":objId,"fileIds":fileIds};
        action.setParams(params);
        console.log ('deleting file ', fileIds);
        this.showSpinner(cmp);
        action.setCallback(this, function(response) {
            try {
                this.hideSpinner(cmp);
                var state = response.getState();
                if (cmp.isValid() && state === "SUCCESS") {
                      console.log ('done marking delete files', response.getReturnValue());                  
                      cmp.set ("v.fileList", response.getReturnValue());
                    
                    
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
    getCheckedFileIds: function(cmp){
        var fileIds = [];
        var fileList = cmp.get('v.fileList');
        for (var i = 0; i < fileList.length; i++) {
            if(document.getElementById('file_'+fileList[i].Id).checked){
            	fileIds.push(fileList[i].Id)
            }
        }
        
        return fileIds;
    },
    
    getObjId: function(cmp){
        var url = decodeURIComponent(window.location.search.substring(1));
        var num = url.split('=');

		//alert(num[0] + ' = ' + num[1]);
        return num[1];
    }
      
})