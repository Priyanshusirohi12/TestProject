@IsTest
public with sharing class TC_DataUtilTest {
    @TestSetup
    public static void setUp() {
        Account a = new Account();
        a.Name = 'test';
        insert a;
    }

    @IsTest
    public static void queryObjectFieldsTest() {
        Test.startTest();
        List <SObject> accounts = TC_DataUtil.queryObjectFields('Account', 'Name = \'test\'');
        List <SObject> accounts2 = TC_DataUtil.queryObjectFields('Account', 'Error = \'test\'');
        Test.stopTest();
        System.assert(accounts <> null);
        System.assert(accounts2 <> null);
    }


    @IsTest
    public static void createSelectAllQueryStringTest() {
        Test.startTest();
        TC_DataUtil.createSelectAllQueryString('Account', 'Name = \'test\'', null);
        TC_DataUtil.createSelectAllQueryString('Account', '', null);
        Test.stopTest();
    }
}