/**
 * Created on 12/28/17.
 */
({
    handleUploadFinished : function (cmp, event, helper) {
        var uploadedFiles = event.getParam("files");
        console.log("Files uploaded : ", uploadedFiles);
        helper.getFileList(cmp);
    },
    
    doInit : function (cmp, event, helper) {
        helper.getFileList(cmp);
    },

    goToNext : function (cmp, event, helper) {
        var navEvent = $A.get("e.c:tc_applicationNavigation_evt");
        var dir = "next";
        
        navEvent.setParams({
            data: {
                direction: dir
            }
        });
        
        navEvent.fire();
    }
})