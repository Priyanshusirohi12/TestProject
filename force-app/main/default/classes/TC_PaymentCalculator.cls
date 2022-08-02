/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 10/20/2015
* @description: Utility class for calculating a loan payment
*
* © Copyright 2003 - 2015 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/


global class TC_PaymentCalculator {

    public static final Integer MONTHLY_INT = 1;
    public static final Integer QUARTERLY_INT = 3;
    public static final Integer SEMI_ANNUAL_INT = 6;
    public static final Integer ANNUAL_INT = 12;

    public static final Integer MONTHLY_INT_INT = 12;
    public static final Integer QUARTERLY_INT_INT = 4;
    public static final Integer SEMI_ANNUAL_INT_INT = 2;
    public static final Integer ANNUAL_INT_INT = 1;

    public static final String MONTHLY_STR = 'Monthly';
    public static final String QUARTERLY_STR = 'Quarterly';
    public static final String SEMI_ANNUAL_STR = 'Semi-Annual';
    public static final String ANNUAL_STR = 'Annual';

    public class TC_InvalidPaymentFrequencyException extends Exception {
    }


    // webservice method that's called when the calculate button is clicked
    webservice static void calculatePayment (String quoteOptionId) {
        runCalculatePayment(quoteOptionId);
    }

    // Invocable method to be call when a payment option is saved
    @InvocableMethod(label='Calculate' description='Calculates Payment Option')
    public static void calculatePayment (List<String> idList) {
        for (String id : idList) {
            System.debug('>>>>> id: ' + id);
            runCalculatePayment(id);
        }

    }

    // Calculate body
    static void runCalculatePayment (String quoteOptionId) {
        Quote_Option__c quoteOption = getQuoteOption(quoteOptionId);
        calculatePayment (quoteOption);
        update quoteOption;
    }

    static Decimal getPaymentsPerYear (String frequency) {
        Map <String, Decimal> paymentsMap = new Map <String, Decimal> {
            MONTHLY_STR => 12,
            QUARTERLY_STR => 4,
            SEMI_ANNUAL_STR => 6,
            ANNUAL_STR => 1

            };
        return paymentsMap.get(frequency);
    }

    //Calculates the paymetn based on the data contained in the payment calculator object
    public static Quote_Option__c calculatePayment (Quote_Option__c quoteOption) {
        Decimal financedAmount = quoteOption.Finance_Amount__c;
        Integer term = Integer.valueOf(quoteOption.Number_of_Months__c);

        String paymentFrequency = quoteOption.Payment_Frequency__c;
        Decimal interestRate = quoteOption.Interest_Rate__c;
        Decimal balloonAmount = quoteOption.Balloon_Amount__c;
        Boolean paymentsInAdvanceAndNotInArrears = quoteOption.Payments_in_Advance_or_Arrears__c != null && quoteOption.Payments_in_Advance_or_Arrears__c == 'Advance' ? true : false;
        Decimal numOfAdvancedPayments = quoteOption.Advanced_Payments__c != null ? Decimal.valueOf (quoteOption.Advanced_Payments__c) : 0;
        Decimal paymentsPerYear = quoteOption.Payments_Per_Year__c == null ? getPaymentsPerYear (quoteOption.Payment_Frequency__c) : quoteOption.Payments_Per_Year__c;


        if (paymentsInAdvanceAndNotInArrears || numOfAdvancedPayments == 0) {
            quoteOption.Payment_Amount__c = calculatePayment (financedAmount, term, paymentFrequency, interestRate, balloonAmount, paymentsInAdvanceAndNotInArrears);
            quoteOption.Advanced_Payment_Amount__c = null;
        } else {
        

            System.debug('calculatePayment ****** ');
            System.debug('financedAmount ->' + financedAmount);
            System.debug('numOfAdvancedPayments ->' + numOfAdvancedPayments);
            System.debug('interestRate ->' + interestRate);
            System.debug('balloonAmount ->' + balloonAmount);
            System.debug('paymentFrequency ->' + paymentFrequency);

            quoteOption.Payment_Amount__c = calculatePayment (financedAmount, ((term * paymentsPerYear) / 12).round (), (interestRate / 100), balloonAmount, paymentsPerYear, numOfAdvancedPayments);
            quoteOption.Advanced_Payment_Amount__c = calculatePayment (financedAmount, term, paymentFrequency, interestRate, balloonAmount, paymentsInAdvanceAndNotInArrears) - quoteOption.Payment_Amount__c;
        }

        return quoteOption;


    }

    //Calculates payment based on a number of individual parameters passed in
    public static Decimal calculatePayment (Decimal financedAmount, Integer term, String paymentFrequency, Decimal ratePercent, Decimal balloonAmount, Boolean advance) {
        Decimal numberOfPayments = term / getFrequencyInt(paymentFrequency);
        Double interestRate = ratePercent / 100 / getFrequencyIntInt(paymentFrequency);
        Decimal paymentAmount = calculatePayment (financedAmount, numberOfPayments, interestRate, balloonAmount, advance).setScale(2, Roundingmode.HALF_UP);
        return paymentAmount;
    }

    //Returns the Frequency integer to be used in calculating payment.
    private static Integer getFrequencyInt (String frequency) {

        Integer frequency_int = 999;
        if (frequency.equalsIgnoreCase(MONTHLY_STR)) frequency_int = MONTHLY_INT; else if (frequency.equalsIgnoreCase(QUARTERLY_STR)) frequency_int = QUARTERLY_INT; else if (frequency.equalsIgnoreCase(SEMI_ANNUAL_STR)) frequency_int = SEMI_ANNUAL_INT; else if (frequency.equalsIgnoreCase(ANNUAL_STR)) frequency_int = ANNUAL_INT; else throw new TC_InvalidPaymentFrequencyException ('Only Monthly, Quarterly, Semi-Annual, and Annual frequencies are supported.');
        return frequency_int;
    }

    //Returns the denominator for the interest rate
    private static Integer getFrequencyIntInt (String frequency) {

        Integer frequency_int = 0;
        if (frequency.equalsIgnoreCase(MONTHLY_STR)) frequency_int = MONTHLY_INT_INT; else if (frequency.equalsIgnoreCase(QUARTERLY_STR)) frequency_int = QUARTERLY_INT_INT; else if (frequency.equalsIgnoreCase(SEMI_ANNUAL_STR)) frequency_int = SEMI_ANNUAL_INT_INT; else if (frequency.equalsIgnoreCase(ANNUAL_STR)) frequency_int = ANNUAL_INT_INT; else throw new TC_InvalidPaymentFrequencyException ('Only Monthly, Quarterly, Semi-Annual, and Annual frequencies are supported.');
        return frequency_int;
    }


    //Returns the payment calculator object based on ID
    private static Quote_Option__c getQuoteOption (String id) {
        Quote_Option__c qo = [
            SELECT Id,
                Name,
                finance_amount__c,
                Number_of_Months__c,
                payment_frequency__c,
                interest_rate__c,
                balloon_amount__c,
                payment_amount__c,
                Advanced_Payments__c,
                Payments_Per_Year__c,
                Payments_in_Advance_or_Arrears__c
            FROM Quote_Option__c
            WHERE Id = :id
        ];
        return qo;
    }

    //Returns the decimal representing the payment amount.
    private static Decimal calculatePayment (Decimal financedAmount, Decimal numberOfPayments, Double interestRate, Decimal residualValue, Boolean advance) {
        System.debug('calculatePayment ****** ');
        System.debug('financedAmount ->' + financedAmount);
        System.debug('numberOfPayments ->' + numberOfPayments);
        System.debug('interestRate ->' + interestRate);
        System.debug('residualValue ->' + residualValue);


        Decimal paymentAmount = interestRate / (Math.pow(1 + interestRate, Double.valueOf(numberOfPayments)) - 1) * -(financedAmount * Math.pow(1 + interestRate, Double.valueOf(numberOfPayments)) + (-1 * residualValue));
        if (advance) {
            paymentAmount = paymentAmount / (1 + interestRate);
        }
        return -1 * paymentAmount;
    }

    public static Decimal calculatePayment (Decimal financedAmount, Decimal numberOfPayments, Decimal ratePercent, Decimal residualValue, Decimal paymentsPerYear, Decimal advancedPayments) {


        System.debug('calculatePayment ****** ');
        System.debug('financedAmount ->' + financedAmount);
        System.debug('numberOfPayments ->' + numberOfPayments);
        System.debug('ratePercent ->' + ratePercent);
        System.debug('residualValue ->' + residualValue);
        System.debug('paymentsPerYear ->' + paymentsPerYear);
        System.debug('advancedPayments ->' + advancedPayments);

        Decimal returnValue = 0;
        try {
            returnValue = ((financedAmount - residualValue / Math.pow(Double.valueOf ((1 + ratePercent / paymentsPerYear)), Double.valueOf (numberOfPayments))) / ((1 - Math.pow(Double.valueOf ((1 + ratePercent / paymentsPerYear)), Double.valueOf (-(numberOfPayments - advancedPayments)))) / (ratePercent / paymentsPerYear) + advancedPayments)).setScale(2, Roundingmode.HALF_UP);
        } catch (Exception e) {
            System.debug (e);
            return returnValue;
        }
        return returnValue;
    }

}