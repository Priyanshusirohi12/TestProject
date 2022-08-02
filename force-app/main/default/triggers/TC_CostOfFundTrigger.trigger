trigger TC_CostOfFundTrigger on Cost_of_Fund__c (after insert, after update, after delete) {
    
    // Custom SMFL logic for using COF records to calculate COF rate
    TC_CostOfFundTriggerHelper.updateCOFInformation();

}