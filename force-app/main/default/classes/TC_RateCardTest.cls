@isTest

private class TC_RateCardTest {
    @testSetup
    static void setupData () {

        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.CloseDate = Date.today();
        opp.StageName = 'test';
        insert opp;

        TCRE__Rule_Config__c conf = new TCRE__Rule_Config__c();
        conf.TCRE__Priority__c = 1;
        conf.TCRE__SObject_Name__c = 'Opportunity';
        insert conf;

        TCRE__Rule_Condition__c cond = new TCRE__Rule_Condition__c();
        cond.TCRE__Rule_Config__c = conf.Id;
        cond.TCRE__Field_Name__c = 'StageName';
        cond.TCRE__Operator__c = '=';
        cond.TCRE__Value__c = 'test';
        insert cond;

        RateCard__c rc = new RateCard__c();
        rc.Name = 'Mtest';
        rc.Entry_Criteria__c = conf.Id;
        insert rc;

        Rate_Card_Column__c col = new Rate_Card_Column__c();
        col.Rate_Card__c = rc.Id;
        col.Column_Criteria__c = conf.Id;
        insert col;

        Rate_Card_Row__c row = new Rate_Card_Row__c();
        row.Rate_Card__C = rc.Id;
        row.Row_Criteria__c = conf.Id;
        insert row;

        Rate_Card_Rate__c rate = new Rate_Card_Rate__c();
        rate.Rate__c = 10;
        rate.Rate_Card_Column__c = col.Id;
        rate.Rate_Card_Row__c = row.Id;

    }


    @isTest
    static void testCtrl () {

        Test.startTest();
        RateCard__c rc = [SELECT Id FROM RateCard__c LIMIT 1];

        List <Rate_Card_Column__c> cols = TC_RateCardCtrl.getColumns(rc.Id);
        List <Rate_Card_Row__c> rows = TC_RateCardCtrl.getRows(rc.Id);

        cols = TC_RateCardCtrl.saveRateCardValues (rc.Id, cols[0].Rate_Card_Rates__r);

        Test.stopTest();

    }

    @isTest
    static void testCtrlExceptions () {

        Test.startTest();

        List <Rate_Card_Column__c> cols;
        try {
            cols = TC_RateCardCtrl.saveRateCardValues ( UserInfo.getUserId() , null);
        }catch(Exception e){
            //exception
        }

        Test.stopTest();

    }

    @isTest
    static void testApex () {

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        TC_RateCardRules.getRate( new List<Id> {opp.Id} );



        Test.stopTest();

    }
}