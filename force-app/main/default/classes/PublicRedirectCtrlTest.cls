/**
 * Created on 3/31/18.
 */

@IsTest
private class PublicRedirectCtrlTest {
    @IsTest
    static void testCreateUrl () {



        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpXMLResponseGenerator ());
        PublicRedirectCtrl ctrl = new PublicRedirectCtrl ();
        ctrl.createUrl();
        ctrl.navigatToPublicPageSecurely();

        Test.stopTest();
    }
}