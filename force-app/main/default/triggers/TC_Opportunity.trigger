trigger TC_Opportunity on Opportunity (before insert, before update, after insert, after update) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TC_OpportunityTriggerHelper.updateCOF_LTSInformation(null, Trigger.new);
        } else if (Trigger.isUpdate) {
            TC_OpportunityTriggerHelper.updateCOF_LTSInformation(Trigger.oldMap, Trigger.new);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //TC_OpportunityTriggerHelper.shareWithOriginator (null, Trigger.newMap);
            TC_OpportunityTriggerHelper.originatorEmailChanged (null, Trigger.newMap);
            TC_OpportunityTriggerHelper.updateLOCUsedAmount(null, Trigger.newMap);
        } else if (Trigger.isUpdate) {
            //TC_OpportunityTriggerHelper.shareWithOriginator (Trigger.oldMap, Trigger.newMap);
            TC_OpportunityTriggerHelper.originatorEmailChanged (Trigger.oldMap, Trigger.newMap);
            TC_OpportunityTriggerHelper.updateLOCUsedAmount(Trigger.oldMap, Trigger.newMap);
        }

    }

}