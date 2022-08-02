({
    doInit: function(cmp, event, helper) {
        cmp.set('v.vfOriginUrl', window.location.href);
//cmp.set("v.recordDetails", {Id:'0064100000LuGcI'});
        console.log('uploader init with recordDetails', cmp.get("v.recordDetails"));
        
        helper.doInit(cmp);
        
        window.addEventListener("message", function(event) {
                  
            //if (event.origin !== event.data.pageUrl.split('/public')[0]) {
            // Not the expected origin: Reject the message!
            //    return;
            //}
            // Handle the message
            console.log('got data from ' + event.origin, event.data);
            
            if (event.data.success) {
                //file uploaded
                var fileList = cmp.get('v.fileList');
                fileList.push(event.data);
                cmp.set('v.fileList', fileList);
                var changeEvent = cmp.getEvent('tc_dealDocsListChange_evt');
                changeEvent.setParams({
                    files: fileList
                });
                changeEvent.fire();
            }
            
            
            helper.hideSpinner(cmp);
        }, false);
                
    },
    
    handleFilesChange: function(cmp, event, helper) {
        helper.showSpinner(cmp);
        var files = event.getSource().get("v.files");
        
        console.log('handleFilesChange', files);
        var iframe = cmp.find('uploaderFrame').getElement().contentWindow;
        console.log('handleFilesChange post message to iframe ', iframe);
        
        console.log('v.recordDetails = ' + cmp.get("v.recordDetails").Id);
        console.log('Id = ' + cmp.get("v.recordDetails").Id);
        
        var fileData = {
            hasFile: true,
            file: files[0],
            parentId: cmp.get("v.recordDetails").Id,
            rootItemId: cmp.get("v.recordDetails").rootItemId,
            source: cmp.get("v.documentSource"),
            description: 'uploaded from public page',
            guestUserId : cmp.get('v.guestUserId')
        };
        
        iframe.postMessage(fileData, cmp.get("v.vfOriginUrl"));
        
    },
})