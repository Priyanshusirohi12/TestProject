/**
 * Created by tamarack on 12/31/19.
 */

@isTest
public with sharing class TC_ProposalPDFCtrlTest {

    @testSetup
    private static void createData() {

        Account a = new Account(Name = 'Proposal PDF Account');
        insert a;

        Opportunity opp = new Opportunity();
        opp.Name = 'Proposal PDF Opportunity';
        opp.AccountId = a.Id;
        opp.Amount = 10000;
        opp.StageName = 'Pipeline';
        opp.CloseDate = System.today();
        insert opp;

        Equipment__c equipment = new Equipment__c(Name='Test Description', Quantity__c = 3, Cost_Per_Unit__c = 4.00
                , Opportunity__c =  opp.Id);
        insert equipment;


        if (Type.forName('Quote_Option__c') != null) {
            sObject quoteOption = Schema.getGlobalDescribe().get('Quote_Option__c').newSObject();
            quoteOption.put('Opportunity__c', opp.Id);
            insert quoteOption;
        }

    }

    @isTest
    public static void grabDocWrapperTest() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        TC_ProposalPDFCtrl.grabDocWrapper(opp.Id);
        Test.stopTest();

    }

}