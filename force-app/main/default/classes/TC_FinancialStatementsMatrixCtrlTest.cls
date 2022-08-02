/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 10/20/2015
* @description: Test class for utility class for TC_FinancialStatementsMatrixCtrl
*
* © Copyright 2003 - 2015 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/

@isTest
public with sharing class TC_FinancialStatementsMatrixCtrlTest {

     static testMethod void calculatePaymentTest() {

         Account acc = new Account (Name = 'test');
         insert acc;
         
         String strId = String.valueOf(acc.Id);
         
		List <Financial_Statement__c> fsList0 = TC_FinancialStatementsMatrixCtrl.initStatements (strId);
         
        Financial_Statement__c fs = new Financial_Statement__c (Account__c = acc.Id);
        insert fs;
        
        
        List <Financial_Statement__c> fsList = TC_FinancialStatementsMatrixCtrl.initStatements (fs.Account__c);

        fsList = TC_FinancialStatementsMatrixCtrl.saveFinancialStatements (fsList, fs.Account__c);
        fsList = TC_FinancialStatementsMatrixCtrl.addFinancialStatement (fsList, fs.Account__c);
                  
        Date tryDate;
        tryDate = TC_FinancialStatementsMatrixCtrl.validateDate('12/12/2012');
        //tryDate = TC_FinancialStatementsMatrixCtrl.validateDate('12345');
       
       
     }



}