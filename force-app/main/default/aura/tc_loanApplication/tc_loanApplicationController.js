/**
 * Created on 12/18/17.
 */
({
    doInit: function (cmp, event, helper) {
        if (!cmp.get('v.fromDetail')) {
            cmp.set('v.recordId', helper.getPageParameters(cmp).id);
            console.log('doInit', cmp.get('v.recordId'));
            helper.getApplicationRecordById(cmp);
        }
    },

    refreshDealGuarantorsComponent: function (cmp, event, helper) {
        helper.refreshDealGuarantorsView(cmp);
    },

    refreshDealEquipmentComponent: function (cmp, event, helper) {
        helper.refreshDealEquipmentView(cmp);
    },

    refreshDealReviewComponent: function (cmp, event, helper) {
        helper.calculateTotalFinanceAmount(cmp);
        helper.refreshView(cmp);
    },

    refreshDealDetailsComponent: function (cmp, event, helper) {
        helper.calculateTotalFinanceAmount(cmp);
        helper.refreshDealDetailsView(cmp);
    },

    handleTabNavigation: function (cmp, event, helper) {

        var navEventData = event.getParam('data');
        console.log('event triggered handleTabNavigation', navEventData);
        var currentStep = cmp.get('v.currentStep');
        var stepIndex = currentStep.split('_')[1];

        if (navEventData.direction === 'next') {
            stepIndex++;
            cmp.set('v.currentStep', 'step_' + stepIndex);
        } else if (navEventData.direction === 'prev') {
            stepIndex--;
            cmp.set('v.currentStep', 'step_' + stepIndex);
        }
    },

    handleStepClick: function (cmp, event, helper) {
        var currentStep = event.getSource().get('v.value');
        cmp.set('v.currentStep', currentStep);
        helper.showHideButtons(cmp);
    },

    handleTabSelect: function (cmp, event, helper) {
        var selectedTabId = event.getSource().get('v.selectedTabId');
        cmp.set('v.currentStep', selectedTabId);
    },


    goToNext: function (cmp, event, helper) {
        var currentStep = cmp.get('v.currentStep');
        var stepIndex = currentStep.split('_')[1];
        stepIndex++;
        cmp.set('v.currentStep', 'step_' + stepIndex);
    },

    goToBack: function (cmp, event, helper) {
        var currentStep = cmp.get('v.currentStep');
        var stepIndex = currentStep.split('_')[1];
        stepIndex--;
        cmp.set('v.currentStep', 'step_' + stepIndex);
    },

    cancel: function (cmp, event, helper) {
        var modalBody;
        $A.createComponent("c:tc_cancelDialogMessage", {
                confirmAction: helper.navigateToHome
            },
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    cmp.find('overlayLib').showCustomModal({
                        header: "Warning - all changes will be lost!",
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: "cancelModal",
                        closeCallback: function () {
                            concole.log('modal closed');
                        }
                    })

                }

            });
    },

    quickSave: function (cmp, event, helper) {
        helper.saveRecords(cmp, event, helper);
    },

    submitDeal: function (cmp, event, helper) {
        helper.submitDeal(cmp);
    },

    //Function to handle the LookupChooseEvent. Sets the chosen record.
    handleCompanyChoose: function (cmp, event, helper) {
        helper.selectCompany(cmp, event);
    },


})