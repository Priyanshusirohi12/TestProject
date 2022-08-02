//Need to Rewrite Variables

public class NT_LenderCriteriaTriggerHelper {

    Public static void LenderCriteriaRollup (List<LenderMatrix__Lender_Criteria__c> opps){
        //Collect Opp Id's for new lms    
        Set<Id> lmIds = new set<Id>();   
        for(LenderMatrix__Lender_Criteria__c opp : opps){
            lmIds.add(opp.opportunity__c);
        }
        
        //Query all parent LMs and Child opps
        List<Opportunity> lms = [
            SELECT Id, LenderMatrix__Lender_Criteria__c,
            
            (   
                SELECT Id, Opportunity__c /*, Paid_Date__c, Pre_funding__c */
                FROM Lender_Criteria__r 
            ) 
            FROM Opportunity  
            WHERE Id IN :lmIds 
        ];    
        System.debug('Opps: ' + opps); 
        System.debug('lms query'+lms);
        
        //Loop over all opps 
        for(Opportunity  lm : lms){
            System.debug('Lms = ' + lms);
           // opp.Vendor_Paid_Date__c = '';
           System.debug('Lm O'+lm.LenderMatrix__Lender_Criteria__c);
            
            //Loop over child opps
            for(LenderMatrix__Lender_Criteria__c o : lm.Lender_Criteria__r){
                System.debug('Child o = ' + o);        
                
                //Set Opportunity Vendor Paid Date                
                String d = '';//o.Paid_Date__c.format();  
                
                if(o.Opportunity__c /*Pre_funding__c*/ != null){
                lm.LenderMatrix__Lender_Criteria__c = o.id;
                }
                     
            }              
            
        }  
        Update lms;
      //  System.debug('This Worked ' + lms);
        
    }
    
}