@isTest
public class TC_CommissionsTest {
    @isTest
    static void testGenerateRecords() {


        Commission_Config__c conf = new Commission_Config__c();
        conf.Discount_Rate__c = .10;
        conf.User_1_Field__c = 'foo';
        conf.User_2_Field__c = 'foo';
        conf.User_3_Field__c = 'foo';
        conf.User_4_Field__c = 'foo';

        try{
            insert conf;
        }catch(Exception e){
            //do nothing
        }

        Commission_Config__c conf2 = new Commission_Config__c();
        conf2.Discount_Rate__c = .10;
        conf2.User_1_Field__c = 'StageName';
        conf2.User_2_Field__c = 'StageName';
        conf2.User_3_Field__c = 'StageName';
        conf2.User_4_Field__c = 'StageName';

        try{
            insert conf2;
        }catch(Exception e){
            //do nothing
        }


        Commission_Config__c conf3 = new Commission_Config__c();
        conf3.Discount_Rate__c = .10;
        conf3.User_1__c = .5;
        conf3.User_1_Field__c = 'OwnerId';
        conf3.User_2__c = .5;
        conf3.User_2_Field__c = 'OwnerId';
        conf3.User_3__c = .5;
        conf3.User_3_Field__c = 'OwnerId';
        conf3.User_4__c = .5;
        conf3.User_4_Field__c = 'OwnerId';
        conf3.Commission_Basis__c = 'Total Commission %';
        conf3.Total_Commission__c = 100;
        insert conf3;

        Application_Condition__c ac = new Application_Condition__c();
        ac.Field_API_Name__c = 'StageName';
        ac.Operator__c = '=';
        ac.Value__c = 'test';
        ac.Commission_Config__c = conf3.Id;
        insert ac;

        Application_Condition__c ac2 = new Application_Condition__c();
        ac2.Field_API_Name__c = 'Amount';
        ac2.Operator__c = '=';
        ac2.Value__c = '123';
        ac2.Commission_Config__c = conf3.Id;
        insert ac2;

        Opportunity opp = new Opportunity();
        opp.CloseDate = Date.today();
        opp.StageName = 'test';
        opp.Name = 'Test';
        opp.Amount = 123;
        insert opp;

        Commission__c comm = new Commission__c();
        comm.Active__c = TRUE;
        comm.Opportunity__c = opp.Id;
        comm.Total_Commission__c = 100;
        comm.User_1_Commission__c = 100;
        comm.User_2_Commission__c = 100;
        comm.User_3_Commission__c = 100;
        comm.User_4_Commission__c = 100;
        insert comm;

    }

    @isTest
    static void testGenerateRecords2() {

        Commission_Config__c conf3 = new Commission_Config__c();
        conf3.Discount_Rate__c = .10;
        conf3.User_1__c = .5;
        conf3.User_1_Field__c = 'OwnerId';
        conf3.User_2__c = .5;
        conf3.User_2_Field__c = 'OwnerId';
        conf3.User_3__c = .5;
        conf3.User_3_Field__c = 'OwnerId';
        conf3.User_4__c = .5;
        conf3.User_4_Field__c = 'OwnerId';
        conf3.Commission_Basis__c = 'Total Commission %';
        conf3.Total_Commission__c = 100;
        insert conf3;

        Application_Condition__c ac = new Application_Condition__c();
        ac.Field_API_Name__c = 'StageName';
        ac.Operator__c = '=';
        ac.Value__c = 'test';
        ac.Commission_Config__c = conf3.Id;
        insert ac;

        Application_Condition__c ac2 = new Application_Condition__c();
        ac2.Field_API_Name__c = 'Amount';
        ac2.Operator__c = '>';
        ac2.Value__c = '123';
        ac2.Commission_Config__c = conf3.Id;
        insert ac2;

        Application_Condition__c ac3 = new Application_Condition__c();
        ac3.Field_API_Name__c = 'Amount';
        ac3.Operator__c = '>';
        ac3.Value__c = '133';
        ac3.Commission_Config__c = conf3.Id;
        insert ac3;

        Application_Condition__c ac4 = new Application_Condition__c();
        ac4.Field_API_Name__c = 'Amount';
        ac4.Operator__c = '<';
        ac4.Value__c = '143';
        ac4.Commission_Config__c = conf3.Id;
        insert ac4;

        Application_Condition__c ac5 = new Application_Condition__c();
        ac5.Field_API_Name__c = 'Amount';
        ac5.Operator__c = '>=';
        ac5.Value__c = '153';
        ac5.Commission_Config__c = conf3.Id;
        insert ac5;

        Application_Condition__c ac6 = new Application_Condition__c();
        ac6.Field_API_Name__c = 'Amount';
        ac6.Operator__c = '<=';
        ac6.Value__c = '163';
        ac6.Commission_Config__c = conf3.Id;
        insert ac6;

        Application_Condition__c ac7 = new Application_Condition__c();
        ac7.Field_API_Name__c = 'Amount';
        ac7.Operator__c = '!=';
        ac7.Value__c = '173';
        ac7.Commission_Config__c = conf3.Id;
        insert ac7;

        Application_Condition__c ac8 = new Application_Condition__c();
        ac8.Field_API_Name__c = 'StageName';
        ac8.Operator__c = 'Includes';
        ac8.Value__c = '183';
        ac8.Commission_Config__c = conf3.Id;
        insert ac8;

        Opportunity opp = new Opportunity();
        opp.CloseDate = Date.today();
        opp.StageName = 'test';
        opp.Name = 'Test';
        opp.Amount = 123;
        insert opp;

        Commission__c comm = new Commission__c();
        comm.Active__c = TRUE;
        comm.Opportunity__c = opp.Id;
        comm.Total_Commission__c = 100;
        comm.User_1_Commission__c = 100;
        comm.User_2_Commission__c = 100;
        comm.User_3_Commission__c = 100;
        comm.User_4_Commission__c = 100;
        insert comm;

    }
}