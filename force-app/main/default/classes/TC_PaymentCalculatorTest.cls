/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 10/20/2015
* @description: Test class for utility class for calculating a loan payment
*
* © Copyright 2003 - 2015 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/

@isTest
public with sharing class TC_PaymentCalculatorTest {

    static testMethod void calculatePaymentTest() {
        Decimal paymentAmount = TC_PaymentCalculator.calculatePayment (100000, 36, 'Monthly', 5, 10000, false);
        System.assertEquals (paymentAmount.toPlainString(), '2739.05');

    }
/*
     static testMethod void calculatePaymentTest2() {
        Quote_Option__c quoteOption = createCalculator();
        TC_PaymentCalculator.calculatePayment (quoteOption);
        System.assertEquals (quoteOption.interest_payment_amount__c.toPlainString(), '33809.39');

     }*/

    static testMethod void calculatePaymentTest3() {
        Quote_Option__c quoteOption = createCalculator();
        insert quoteOption;
        TC_PaymentCalculator.calculatePayment (quoteOption.id);
        //Verify the underlying object input did not change.
        System.assertEquals (quoteOption.payment_frequency__c, 'Annual');
    }


    private static Quote_Option__c createCalculator()
    {
        Quote_Option__c quoteOption = new Quote_Option__c();
        quoteOption.finance_amount__c = 100000;
        quoteOption.Number_of_Months__c = 36;

        quoteOption.payment_frequency__c = 'Annual';
        quoteOption.interest_rate__c = 10;
        quoteOption.balloon_amount__c = 10000;
        //quoteOption.Payments_in_Advance_or_Arrears__c = 'Arrears';
        return quoteOption;

    }


}