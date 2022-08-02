/**
 * Created by szheng on 2019-11-23.
 */

({

    addEmailClickHelper : function(cmp, event, helper) {

        var newEmailInput = cmp.find('newEmailInput');
        var newEmailValidity = newEmailInput.get('v.validity').valid;
        var newEmail = cmp.get('v.newEmail');

        if (newEmailValidity && newEmail != '') {
            var lenderListEnabled = cmp.get('v.lenderListEnabled');
            var duplicateEmail = lenderListEnabled.some(el => el.value === newEmail);

            if (duplicateEmail) {
                newEmailInput.setCustomValidity('You have entered a duplicate email.');
                newEmailInput.reportValidity();
            } else {
                lenderListEnabled.push({'label': newEmail, 'value': newEmail});
                cmp.set('v.lenderListEnabled', lenderListEnabled);

                var wrapperLenderList = cmp.get('v.wrapper.selectedEmailList');
                wrapperLenderList.push(newEmail);
                cmp.set('v.wrapper.selectedEmailList', wrapperLenderList);
                this.setFundingSourceRecords(cmp);

                cmp.set('v.newEmail', '');
            }
        }
        newEmailInput.setCustomValidity('');

    },

    setLenderCheckboxes : function(cmp, lender) {

        var wrapperLenderList = cmp.get('v.wrapper.lenderList');
        wrapperLenderList.push(lender);
        cmp.set('v.wrapper.lenderList', wrapperLenderList);

        var lenderListEnabled = cmp.get('v.lenderListEnabled');
        var lenderListDisabled = cmp.get('v.lenderListDisabled');

        if (lender.Funding_Email__c != undefined && lender.Funding_Email__c != null) {
            var label = lender.Name + ' (' + lender.Funding_Email__c + ')';
            lenderListEnabled.push({'label': label, 'value': lender.Funding_Email__c});

            var wrapperSelectedEmailList = cmp.get('v.wrapper.selectedEmailList');
            wrapperSelectedEmailList.push(lender.Funding_Email__c);
            cmp.set('v.wrapper.selectedEmailList', wrapperSelectedEmailList);
        } else {
            var label = lender.Name + ' (N/A)';
            lenderListDisabled.push({'label': label, 'value': null});
        }

        cmp.set('v.lenderListEnabled', lenderListEnabled);
        cmp.set('v.lenderListDisabled', lenderListDisabled);

    },

    updateFilterArray : function (cmp, lender) {

        var wrapperFilterArray = cmp.get('v.wrapper.filterArray');
        wrapperFilterArray.push('Id!=\'' + lender.Id + '\'');
        cmp.set('v.wrapper.filterArray', wrapperFilterArray);

    },

    handleLenderChooseEventHelper : function (cmp, event) {

        var lenderId = event.getParam('recordId');

        if (lenderId) {

            var action = cmp.get('c.selectLender');
            action.setParams({
                recordId : lenderId
            });
            action.setCallback(this, function(result) {

                if (result.getState() === 'SUCCESS') {
                    var returnValue = result.getReturnValue();
                    this.setLenderCheckboxes(cmp, returnValue);
                    this.updateFilterArray(cmp, returnValue);
                    this.setFundingSourceRecords(cmp);
                } else {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Error',
                        'type': 'error',
                        'message': result.getError()[0].message
                    });
                    toastEvent.fire();
                }

            });
            $A.enqueueAction(action);
        }

    },

    setFundingSourceRecords : function(cmp, event) {

        var action = cmp.get('c.setFundingSourceRecords');

        var setFSRecordMap = new Map();
        setFSRecordMap['lenderList'] = JSON.stringify(cmp.get('v.wrapper.lenderList'));
        setFSRecordMap['selectedEmailList'] = JSON.stringify(cmp.get('v.wrapper.selectedEmailList'));
        setFSRecordMap['recordId'] = cmp.get('v.recordId');
        setFSRecordMap['fsWrapperList'] = JSON.stringify(cmp.get('v.wrapper.fsWrapperList'));

        var setFSRecordMapString = JSON.stringify(setFSRecordMap);

        action.setParams({
            setFSRecordMapString : setFSRecordMapString
        });

        action.setCallback(this, function(result) {
            if (result.getState() === "SUCCESS") {
                var fsWrapperList = result.getReturnValue();
                cmp.set('v.wrapper.fsWrapperList', fsWrapperList);
            } else {
                this.showToast('Error', 'error', result.getError()[0].message);
            }
        });

        $A.enqueueAction(action);
    },

    showToast : function(title, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'type': type,
            'message': message
        });
        toastEvent.fire();
    }

});