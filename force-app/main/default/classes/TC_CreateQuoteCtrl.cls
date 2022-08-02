/**
 * Created on 12/8/17.
 */

public without sharing class TC_CreateQuoteCtrl { //needs to be without sharing for guest user to be able to get quotes and opp id.
    public static Quote_Setting__mdt quoteSetting = [
        SELECT Id
            ,Credit_Rating_Config__c
            ,Term_Config__c
            ,Finance_Type__c
            ,Payment_Frequency__c
            ,Account_Name_for_Guest_User__c
            ,Opp_Stage_Name_on_Create__c
        FROM Quote_Setting__mdt
        LIMIT 1
    ];

    @AuraEnabled
    public static List <Quote_Option__c> calculateQuoteOptionsByRateTerm (List <String> terms, Quote_Option__c quoteOption) {

        try {
            List <Quote_Option__c> quoteOptions = new List <Quote_Option__c> ();
            List <Decimal> termValues = new List <Decimal> ();
            for (String term : terms) {
                termValues.add(Decimal.valueOf(term.split(' ')[0]));
            }

            for (Decimal term : termValues) {
                quoteOption.Term_Months__c = term;
                quoteOption.Number_of_Months__c = term; //WTF? :)
                quoteOptions.add(TC_PaymentCalculator.calculatePayment(quoteOption));
            }

            return quoteOptions;
        } catch (Exception ex) {
            System.debug(ex);
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException (ex.getMessage() + ' - ' + ex.getStackTraceString());
        }
    }


    @AuraEnabled
    public static List <Quote_Option__c> calculateQuoteOptionsByRateFactor (List <String> terms, Quote_Option__c quoteOption) {
        try {
            List <Quote_Option__c> quoteOptions = new List <Quote_Option__c> ();
            List <Decimal> termValues = new List <Decimal> ();
            for (String term : terms) {
                termValues.add(Decimal.valueOf(term.split(' ')[0]));
            }

            for (Decimal term : termValues) {
                quoteOption.Term_Months__c = term;
                quoteOption.Number_of_Months__c = term; //WTF? :)
                quoteOption.Payment_Amount__c = quoteOption.Finance_Amount__c * quoteOption.Rate_Factor__c;
                quoteOption.Interest_Rate__c = null;
                quoteOptions.add(quoteOption);
            }

            return quoteOptions;
        } catch (Exception ex) {
            System.debug(ex);
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException (ex.getMessage() + ' - ' + ex.getStackTraceString());
        }
    }

    @AuraEnabled
    public static List <Quote_Option__c> calculateQuoteOptionsByCreditRating (Quote_Option__c quoteOption, List <String> terms, String creditRating) {
        try {

            List <Rate_Factor_Rule__c> rfrList = new List <Rate_Factor_Rule__c> ();
            List <Quote_Option__c> qiList = new List <Quote_Option__c> ();

            Set <String> termSet = new Set <String> ();
            termSet.addAll(terms);

            rfrList = [
                SELECT Id
                    ,Rate_Factor__c
                    ,Payment_Frequency__c
                    ,Term_Months__c
                    ,Term__c
                    ,Minimum_Price__c
                    ,Maximum_Price__c
                    ,Finance_Type__c
                    ,Equipment_Type__c
                FROM Rate_Factor_Rule__c
                WHERE Active__c = true
                AND Minimum_Price__c <= :quoteOption.Finance_Amount__c
                AND Maximum_Price__c >= :quoteOption.Finance_Amount__c
                AND Term__c IN :termSet
                AND Credit_Rating__c = :creditRating
                AND Payment_Frequency__c = :quoteOption.Payment_Frequency__c
                ORDER BY Rate_Factor__c ASC
                LIMIT 1000
            ];

            for (Rate_Factor_Rule__c rfr : rfrList) {
                Quote_Option__c qo = createQuoteOption(rfr, quoteOption);
                qiList.add (qo);
            }
            System.debug(qiList);
            return qiList;
        } catch (Exception ex) {
            System.debug(ex);
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException (ex.getMessage() + ' - ' + ex.getStackTraceString());
        }
    }

    public static Quote_Option__c createQuoteOption (Rate_Factor_Rule__c rfr, Quote_Option__c quoteOption) {
        Quote_Option__c qo = new Quote_Option__c ();

        qo.Finance_Type__c = rfr.Finance_Type__c;
        qo.Payment_Frequency__c = rfr.Payment_Frequency__c;
        qo.Rate_Factor__c = rfr.Rate_Factor__c;
        qo.Term_Months__c = rfr.Term_Months__c;
        qo.Equipment_Type__c = rfr.Equipment_Type__c;
        qo.Include_in_Quote__c = false;
        qo.Quote_Option_Description__c = quoteOption.Quote_Option_Description__c;
        qo.Finance_Amount__c = quoteOption.Finance_Amount__c;

        return qo;
    }

    @AuraEnabled
    public static String initQuoteOptionSelections () {
        try {
            QuoteSelectOption opt = new QuoteSelectOption ();
            opt.finType = getFinanceTypeSelectOptions();
            opt.term = getTermSelectOptions();
            opt.paymentFreq = getPaymentFrequencySelectOptions();
            opt.credRatingOptions = getCreditRatingSelectOptions();
            opt.rateOptions = getRateSelectOptions();
            opt.numOfAdvPaymentsOptions = getNumOfAdvPaymentsOptions();
            return JSON.serialize(opt);
        } catch (Exception ex) {
            System.debug(ex);
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException (ex.getMessage());
        }

    }

    public static List <SelectOptionWrapper> getNumOfAdvPaymentsOptions () {

        List <SelectOptionWrapper> options = new List <SelectOptionWrapper> ();

        Schema.DescribeFieldResult fieldResult = Quote_Option__c.Advanced_Payments__c.getDescribe();
        List <Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOptionWrapper (f.getLabel(), f.getValue(), f.isDefaultValue()));
        }
        return options;
    }

    public static List <SelectOptionWrapper> getRateSelectOptions () {

        List <SelectOptionWrapper> options = new List <SelectOptionWrapper> ();

        options.add(new SelectOptionWrapper ('Based on Credit', 'credit', true));
        options.add(new SelectOptionWrapper ('Specific Int Rate', 'rate', false));
        options.add(new SelectOptionWrapper ('Specific Rate Factor', 'rate_factor', false));

        return options;
    }

    public static List <SelectOptionWrapper> getTermSelectOptions () {
        List <SelectOptionWrapper> options = (List <SelectOptionWrapper>) JSON.deserialize(quoteSetting.Term_Config__c, List <SelectOptionWrapper>.class);
        return options;
    }

    public static List <SelectOptionWrapper> getFinanceTypeSelectOptions () {

        Set <String> defaultOptions = new Set <String> ();

        if (quoteSetting != null && quoteSetting.Finance_Type__c != null)
            defaultOptions.addAll(quoteSetting.Finance_Type__c.split(';'));

        Schema.DescribeFieldResult fieldResult = Rate_Factor_Rule__c.Finance_Type__c.getDescribe();
        List <Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        List <SelectOptionWrapper> options = new List <SelectOptionWrapper> ();

        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOptionWrapper (f.getLabel(), f.getValue(), defaultOptions.contains(f.getLabel())));
        }
        return options;
    }

    public static List <SelectOptionWrapper> getPaymentFrequencySelectOptions () {


        Set <String> defaultOptions = new Set <String> ();
        if (quoteSetting != null && quoteSetting.Payment_Frequency__c != null)
            defaultOptions.addAll(quoteSetting.Payment_Frequency__c.split(';'));

        Schema.DescribeFieldResult fieldResult = Rate_Factor_Rule__c.Payment_Frequency__c.getDescribe();
        List <Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        List <SelectOptionWrapper> options = new List <SelectOptionWrapper> ();

        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOptionWrapper (f.getLabel(), f.getValue(), defaultOptions.contains(f.getLabel())));
        }

        return options;
    }

    public static List <SelectOptionWrapper> getCreditRatingSelectOptions () {
        List <SelectOptionWrapper> options = (List <SelectOptionWrapper>) JSON.deserialize(quoteSetting.Credit_Rating_Config__c, List <SelectOptionWrapper>.class);

        return options;
    }

    @AuraEnabled
    public static String createLoanApplication (String quoteOptionsString) {
        System.debug('createLoanApplication - ' + quoteOptionsString);
        try {

            Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
            Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();


            List <Quote_Option__c> quoteOptions = (List <Quote_Option__c>) JSON.deserialize(quoteOptionsString, List <Quote_Option__c>.class);
            User u = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            Account a = new Account ();

            a.Id = u.ContactId == null ? [SELECT Id FROM Account WHERE NAME = :quoteSetting.Account_Name_for_Guest_User__c LIMIT 1].Id : u.Contact.AccountId;


            Opportunity opp = new Opportunity ();
            opp.RecordTypeId = rtMapByName.get('Equipment Finance').getRecordTypeId();
            opp.CloseDate = System.today() + 1;
            opp.AccountId = a.Id;
            opp.Name = 'Quote Option @$' + quoteOptions[0].Finance_Amount__c + ' - ' + quoteOptions[0].Term_Months__c + ' Months';
            opp.StageName = quoteSetting.Opp_Stage_Name_on_Create__c;
            opp.Amount = quoteOptions[0].Finance_Amount__c;

            TC_WithoutSharingDataUtility.insertOpportunity(opp);

            for (Quote_Option__c qo : quoteOptions) {
                qo.Opportunity__c = opp.Id;
                qo.No_Calculation__c = true;
            }

            TC_WithoutSharingDataUtility.insertQuoteOptions(quoteOptions);

            return opp.Id;

        } catch (Exception ex) {
            System.debug(ex);
            System.debug(ex.getStackTraceString());
            throw new AuraHandledException (ex.getMessage());
        }
    }

    class SelectOptionWrapper {
        public String label;
        public String value;
        public Boolean isSelected;
        public String description;

        public SelectOptionWrapper () {
            this.isSelected = false;
        }

        public SelectOptionWrapper (String label, String value, Boolean isSelected) {

            this (label, value, isSelected, null);
        }

        public SelectOptionWrapper (String label, String value, Boolean isSelected, String description) {

            this.label = label;
            this.value = value;
            this.isSelected = isSelected;
            this.description = description == null ? '' : description;
        }
    }

    class QuoteSelectOption {
        Object paymentFreq;
        Object term;
        Object finType;
        Object equipType;
        Object credRatingOptions;
        Object numOfAdvPaymentsOptions;
        Object rateOptions;
        String defaultCredRating;
    }
}