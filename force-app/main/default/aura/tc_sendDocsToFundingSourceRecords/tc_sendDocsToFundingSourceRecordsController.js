/**
 * Created by szheng on 2019-11-25.
 */

({
    doInit : function(cmp, event, helper) {

        var fsWrapperList = cmp.get('v.fsWrapperList');
        if (fsWrapperList.length == 0) {
            cmp.set('v.message', 'No lenders selected for Funding Source record creation.');
        } else {
            cmp.set('v.message', 'Optional: Create/edit Funding Source records for each Lender email upon sending attachments');
        }

    },

});