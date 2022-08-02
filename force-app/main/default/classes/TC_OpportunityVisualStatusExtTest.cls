/**
* @author : sfdc, Tamarack Consulting, Inc.
* @date : 1/21/2017
* @description: Test class for TC_OpportunityVisualStatusExt.
*
* © Copyright 2003 - 2017 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/

@isTest
public class TC_OpportunityVisualStatusExtTest {
    
    @isTest
    static void test () {
       
        Opportunity opp = new Opportunity();  
        opp.Name = 'Test Opportiunity';  
        opp.CloseDate = System.today();   
        opp.StageName = 'Declined'; 
        insert Opp;        
	
        String stages = TC_OpportunityVisualStatusExt.getStageValues();	
        TC_OpportunityVisualStatusExt.setStageName(opp.Id, 'Canceled');	
        TC_OpportunityVisualStatusExt.parseError('error message');      

    }
}