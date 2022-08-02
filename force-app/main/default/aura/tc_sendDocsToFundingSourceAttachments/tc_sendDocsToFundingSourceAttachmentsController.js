/**
 * Created by szheng on 2019-11-24.
 */

({
    previewFile : function (cmp, event, helper) {
        var rec_id = event.currentTarget.id;
        $A.get('e.lightning:openFiles').fire({
            recordIds: [rec_id]
        });
    },
});