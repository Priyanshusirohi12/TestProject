/**
 * Created on 11/16/18.
 */
({
    doInit: function (cmp, event, helper) {
        console.log('online app init ');
        helper.findPartnerInfo(cmp);
    },

    submitApplication: function (cmp, event, helper) {

        if (helper.checkFields(cmp, event)) {
            helper.submitApp(cmp);
        } else {
            helper.showToast('Error', 'Please review the data. Some fields are invalid.', 'error');
        }
    },

    onSSNChange: function (cmp, event) {
       // console.log(event.getSource().get('v.value'));
        var curVal = event.getSource().get('v.value');
        var val = curVal.replace(/\D/g, '');
        var newVal = '';
        var sizes = [3, 2, 4];

        for (var i in sizes) {
            if (val.length > sizes[i]) {
                newVal += val.substr(0, sizes[i]) + '-';
                val = val.substr(sizes[i]);
            } else
                break;
        }

        newVal += val;
        event.getSource().set('v.value', newVal);
    },

    onPhoneChange: function (cmp, event) {
       // console.log(event.getSource().get('v.value'));
        var curVal = event.getSource().get('v.value');
        var val = curVal.replace(/\D/g, '');
        var newVal = '';
        var sizes = [3, 3, 4];

        for (var i in sizes) {
            if (val.length > sizes[i]) {
                newVal += val.substr(0, sizes[i]) + '-';
                val = val.substr(sizes[i]);
            } else
                break;
        }

        newVal += val;
        event.getSource().set('v.value', newVal);
    },

    onDobChange: function (cmp, event) {
        //console.log(event.getSource().get('v.value'));
        var curVal = event.getSource().get('v.value');
        var val = curVal.replace(/\D/g, '');
        var newVal = '';
        var sizes = [2, 2, 4];
       // console.log(val.length === 8);
        for (var i in sizes) {


            if (val.length > sizes[i]) {

                //check dates
                // if (i==0 && (parseInt(val) > 12 || parseInt(val) < 1)) {
                //     val = 01;
                // }

                newVal += val.substr(0, sizes[i]) + '/';
                val = val.substr(sizes[i]);
            }
        }

        if (val.length === 8) {
            var d = new Date(newVal);
           // console.log(isNaN(d));
            if (isNaN(d)) {
                val = '';
                newVal = '';
            }
        }

        newVal += val;
        event.getSource().set('v.value', newVal);
    },


    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles', uploadedFiles);

        var files = cmp.get('v.uploadedFiles');
        cmp.set('v.uploadedFiles', files.concat(uploadedFiles));

    },

    handleFileUploadEvent: function (cmp, event, helper) {
        var resultData = event.getParam("resultData");
        console.log('handleFileUploadEvent eventdata ', resultData);

        var files = cmp.get('v.files');

        var newFile = resultData.fileData;
        newFile.id = resultData.result.id;

        files.push(newFile);

        cmp.set('v.files', files);
        helper.showToast('File uploaded', 'File Id: ' + newFile.id, 'success');
    },

    deleteFile: function (cmp, event, helper) {
        var action = cmp.get('c.deleteDocument');
        var index = event.getSource().get("v.value");
        console.log(index);
        var fileVar = cmp.get('v.uploadedFiles')[index];
        console.log(fileVar.documentId);
        action.setParams({
            conventVersionId: fileVar.documentId
        });

        action.setCallback(this, function (result) {

            console.log(result);

            if (result.getState() === 'SUCCESS') {
                helper.showToast('Success', 'File deleted', 'success');
                var files = cmp.get('v.uploadedFiles');
                files.splice(index, 1);
                cmp.set('v.uploadedFiles', files);
            } else {

                helper.showToast('Error', result.getError()[0].message, 'error');
            }
        });

        $A.enqueueAction(action);
    }
})