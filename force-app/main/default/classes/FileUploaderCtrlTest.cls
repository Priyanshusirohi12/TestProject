@isTest
private class FileUploaderCtrlTest {
           
    @isTest
    static void test () {  
        
        List<User> us = [SELECT Id FROM User WHERE UserType = 'Guest'];
        User u;
        if (us != null && us.size() > 0) {
            u = us.get(0);
        }
        if (u == null) { return; }
        System.runAs(u){            
            Test.startTest();       
            Test.setMock(HttpCalloutMock.class, new MockHttpXMLResponseGenerator());
            FileUploaderCtrl.initPage();
        }
        
        Test.stopTest(); 
    }
}