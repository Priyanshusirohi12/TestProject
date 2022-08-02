trigger TC_LikeTermSwapTrigger on Like_Term_Swap__c (after insert, after update, after delete) {

    // Custom SMFL logic for using COF records to calculate COF rate
    TC_LikeTermSwapTriggerHelper.updateLTSInformation(Trigger.newMap);
   
}