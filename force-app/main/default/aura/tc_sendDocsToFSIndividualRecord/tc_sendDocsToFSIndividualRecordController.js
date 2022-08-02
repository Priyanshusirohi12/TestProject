/**
 * Created by szheng on 2019-11-25.
 */

({

    addFSRecord : function(cmp, event, helper) {

        var fsWrapper = cmp.get('v.fsWrapper');

        var fsRecord = {};
        fsRecord.sobjectType = 'Funding_Source__c';
        fsRecord.Funding_Source__c = fsWrapper.lender.Id;
        fsRecord.Related_Opportunity__c = cmp.get('v.recordId');
        fsRecord.Status__c = 'Submitted';

        fsWrapper.fs = fsRecord;
        fsWrapper.newRecordBoolean = true;
        cmp.set('v.fsWrapper', fsWrapper);

    },

    deleteFSRecord : function(cmp, event, helper) {

        var fsWrapper = cmp.get('v.fsWrapper');
        fsWrapper.fs = null;
        fsWrapper.newRecordBoolean = false;
        cmp.set('v.fsWrapper', fsWrapper);

    }

});