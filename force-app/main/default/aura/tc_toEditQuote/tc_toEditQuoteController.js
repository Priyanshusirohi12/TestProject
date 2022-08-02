({
    doInit : function(cmp, event, helper) {
                
        var parentId = '';
        var recordId = cmp.get('v.recordId');
        var urlEvent = $A.get("e.force:navigateToURL");
        alert('redirecting');
        urlEvent.setParams({
            "url": "/tvalue-quote?parentId=" + parentId + "&recordId="+row.Id        
        });
                
        urlEvent.fire();
        alert('fires');

    }
})