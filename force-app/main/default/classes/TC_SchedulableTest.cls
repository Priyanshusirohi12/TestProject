/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 03/03/2017
* @description: Schedulable tests
*
* © Copyright 2003 - 2017 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/

@isTest
private class TC_SchedulableTest {
    
    private static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void approvalExpiredSchd () {
        
        insert new Opportunity (Name = 'test', CloseDate = Date.today () + 10, StageName = 'test', Approval_Expiration_Date__c = Date.today () - 90);
        
        Test.startTest();
        TC_CheckApprovalExpiredSchd s = new TC_CheckApprovalExpiredSchd ();
        System.schedule('Job Started At ' + String.valueOf(Datetime.now()), CRON_EXP, s);
        
        Test.stopTest();
    }
    
}