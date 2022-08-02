@isTest public class TC_DeleteRecordCtrlTest {
    @testSetup public static void dmlAccount () {
        insert new Account (Name = 'testdelete');
    }
    @isTest public static void testDelete () {
        Id accId = [SELECT Id FROM Account WHERE Name = 'testdelete'][0].Id;
        TC_DeleteRecordCtrl.deleteRecordById (accId);
        TC_DeleteRecordCtrl.getListViewId();
        
        // test failure criteria for more coverage
        try {
            TC_DeleteRecordCtrl.deleteRecordById (accId);
        } catch (Exception e) {
            System.debug (e);
        }
    }
}