({
    doInit: function (cmp, event, helper) {
        helper.setIsMasterLine(cmp);
        helper.getCompanyRecordById(cmp);
    }
})