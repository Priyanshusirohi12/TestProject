/**
 * Created by szheng on 2019-11-03.
 */

({

    doInit : function(cmp, event, helper) {

        var topicName = cmp.get('v.parentRendered');

        if (topicName) {
            helper.parseEmailTemplate(cmp);
            helper.displayWarningMessage(cmp);
        }

    }

});