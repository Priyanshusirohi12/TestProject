public with sharing class TC_RunRateCardCtrl {

    @AuraEnabled
    public static void runFlow(String recordId) {
        List<Opportunity> oppList = [SELECT Id, Rate_Card_Rate__c FROM Opportunity WHERE Id = :recordId];
        Opportunity opp = oppList[0];
        opp.Rate_Card_Rate__c = TC_RateCardRules.getRate(recordId);
        update opp;
    }
}