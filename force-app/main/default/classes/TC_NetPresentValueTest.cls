@IsTest
public with sharing class TC_NetPresentValueTest {

    @IsTest
    public static void calculateForPaymentTest(){
        Test.startTest();
        Decimal d = TC_NetPresentValue.calculateForPayment(1,1,1,1,1);
        Decimal d2 = TC_NetPresentValue.calculateForPayment(1,-1,0,1,1);
        //
        Decimal d3= TC_NetPresentValue.calculateForPayment(1,1,1,1,0);
        //null check
        Decimal d4 = TC_NetPresentValue.calculateForPayment(null,1,1,1,1);
        Test.stopTest();
        System.assert(d<>null);
    }
    @IsTest
    public static void calculateForAmountTest(){
        Test.startTest();
        Decimal d = TC_NetPresentValue.calculateForAmount(1,1,1,1);
        Decimal d2 = TC_NetPresentValue.calculateForAmount(null,1,1,1);
        Decimal d3 = TC_NetPresentValue.calculateForAmount(1,-1,1,1);
        Test.stopTest();
        System.assert(d<>null);
    }
}