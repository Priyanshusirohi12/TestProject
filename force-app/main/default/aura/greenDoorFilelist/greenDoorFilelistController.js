({
    doInit : function(cmp, event, helper) {
        
        document.title = 'Download Files';
        
        var getUrlParameter = function getUrlParameter(sParam) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;

                for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');

                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        };
        cmp.set('v.recordId', getUrlParameter('recordId'));
        
        
        if (cmp.get('v.recordId')) {
            var action = cmp.get('c.getFilesForRecordId');
            action.setParams ({
                recordId: cmp.get('v.recordId')
            });
            
            action.setCallback(this, function (result){
                console.log(result.getReturnValue());
                if (result.getState()==='SUCCESS') {
                    cmp.set('v.fileList', result.getReturnValue());
                } else {
                    alert (result.getError()[0].message);
                }
            });
            
            $A.enqueueAction (action);
        }
        
    }
})