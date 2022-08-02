/**
 * Created on 12/28/17.
 */
({
    getFileList : function (cmp) {
        console.log('getFileList deal=', cmp.get('v.deal'));
        var action = cmp.get('c.getFilesByParentId');
        action.setParams ({
            parentId: cmp.get('v.deal').Id
        });

        action.setCallback(this, function (result) {
            if (result.getState() === 'SUCCESS') {
                console.log('getFileList success- ', result.getReturnValue());
                cmp.set('v.fileList', result.getReturnValue());
            } else {
                console.log('getFileList error- ', result.getError());
            }
        });

        $A.enqueueAction (action);
    }
})