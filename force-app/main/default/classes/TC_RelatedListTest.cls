@isTest

private class TC_RelatedListTest {

    @testSetup
    static void setupData () {
        Account a = new Account();
        a.name = 'test';
        insert a;
    }

    @isTest
    static void testCtrl () {

        Account a = [SELECT Id FROM Account LIMIT 1];

        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :a.Id];

        String sobjectType = 'Contact';
        String fieldList = 'Name, Id';

        TC_RelatedListCtrl.getRelatedRecords(a.Id, sobjectType);

        TC_RelatedListCtrl.getIconName(a.Id, sobjectType);

        TC_RelatedListCtrl.getColumnData(sobjectType, fieldList);

        TC_RelatedListCtrl.saveRecords(contacts);

        TC_RelatedListCtrl.getObjectPermission();

    }

}