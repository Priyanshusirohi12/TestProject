/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 1/30/2018
* @description: Calculate the Net Present Value for Payments and Amounts
*
* © Copyright 2003 - 2018 Tamarack Consulting, Inc.  All Rights Reserved.
* 
*/
public class TC_NetPresentValue {
       
    public static Decimal calculateForPayment(
        Decimal amount,
        Decimal numPayments, 
        Decimal rate, 
        Decimal compoundFrequency, 
        Decimal advanceArrears // Advance = 1, Arrears = 0 
    ){
        Decimal NPV;

        if(
            amount == NULL
            || numPayments == NULL
            || rate == NULL
            || compoundFrequency == NULL
            || advanceArrears == NULL
        ){
            return NULL;
        }
        
        rate = rate/100;
        numPayments = Math.floor(numPayments);
                
        if(advanceArrears <> 1 && advanceArrears <> 0){
            return null;
        }
            
        if(numPayments < 1 || rate <= 0){
            return null;
        }
        
        NPV = ((amount * (1+rate/compoundFrequency*advanceArrears)) / ( rate/compoundFrequency )) * (1 - (1 / Math.pow((Double)(1 + ( rate/compoundFrequency )), (Double)numPayments) ));
        
        return NPV;
    }

        
    public static Decimal calculateForAmount(
        Decimal amount,
        Decimal numPayments, 
        Decimal rate, 
        Decimal compoundFrequency
    ){
        Decimal NPV;
        
        if(
            amount == NULL
            || numPayments == NULL
            || rate == NULL
            || compoundFrequency == NULL
        ){
            return NULL;
        }
        
        rate = rate/100;
        numPayments = Math.floor(numPayments);
                    
        if(numPayments < 1 || rate <= 0){
            return null;
        }
        
        NPV = amount - (amount * (1 - (1 / Math.pow((Double)(1 + ( rate/compoundFrequency )), (Double)numPayments) )) );
        return NPV;
    }
}