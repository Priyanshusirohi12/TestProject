({
    doInit : function(cmp, event, helper) {
        console.log ('doInit ... ');
        
        //helper.getObjId(cmp);
        
        //var objId = '0064100000LuGcI';
        var objId = helper.getObjId(cmp);
        
        cmp.set("v.objId", objId);
        cmp.set("v.recordDetails", {Id:objId});
        helper.getOpps(cmp);
        helper.getFiles (cmp);
        
        
        window.addEventListener("message", function(event) {
                  
            //if (event.origin !== event.data.pageUrl.split('/public')[0]) {
            // Not the expected origin: Reject the message!
            //    return;
            //}
            // Handle the message
            console.log('PARENT ALSO got data from ' + event.origin, event.data);
          
            if (event.data.success) {
            
            helper.getFiles (cmp);
/*              
                //file uploaded
                var fileList = cmp.get('v.fileList');
                fileList.push(event.data);
                cmp.set('v.fileList', fileList);
                var changeEvent = cmp.getEvent('tc_dealDocsListChange_evt');
                changeEvent.setParams({
                    files: fileList
                });
                changeEvent.fire();
            */
            }
            
            
//            helper.hideSpinner(cmp);

        }, false);

        
    },
    handleDeleteClick : function(cmp, event, helper) {
        var fileIds = helper.getCheckedFileIds(cmp);
        
        if(fileIds.length > 0){
            helper.delFiles(cmp, fileIds);
        }
        
    }, 
    handleUndeleteClick : function(cmp, event, helper) {
        var fileIds = helper.getCheckedFileIds(cmp);
        
        if(fileIds.length > 0){
            helper.undelFiles(cmp, fileIds);
        }
        
    },     
    loadFiles : function(cmp, event, helper) {
        
        helper.getFiles (cmp);
    },  
        

    
})