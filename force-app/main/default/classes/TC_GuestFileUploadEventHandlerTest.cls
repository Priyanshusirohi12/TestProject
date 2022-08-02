/**
 * Created on 2019-02-09.
 */

@isTest
private class TC_GuestFileUploadEventHandlerTest {

    @testSetup
    private static void createData () {

    }


    @isTest
    static void testBehavior () {
        Test.startTest();


        List <Guest_File_Upload__e> fileEvents = new List <Guest_File_Upload__e> {
            new Guest_File_Upload__e (
                Action__c = 'DELETE',
                Document_Id__c = '0695C0000000ou1'
            ),

            new Guest_File_Upload__e (
                Action__c = 'UPDATE',
                Document_Id__c = '0695C0000000ou1'
            )


        };

        List<Database.SaveResult> results = EventBus.publish(fileEvents);

        Test.stopTest();
    }
}