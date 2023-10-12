trigger CaseTrigger on Case (After Update) {
   /* Map <Id,Case> caseMap= new  Map<Id,Case>();
    for(Case caseValue : Trigger.newMap.Values()){
            caseMap.put(caseValue.ContactId,caseValue);
        }
    Map<Id,Hire_Form__c> hireMap= new Map<Id,Hire_Form__c> ();  
    for(Hire_Form__c hire : [Select Id,Name, Candidate__c, Status__c from Hire_Form__c where Candidate__c =: caseMap.keySet()]){
        hireMap.put(hire.Candidate__c, hire);
    }   
    System.debug(hireMap);
    for(Case caseValue : caseMap.values()){
            System.debug('123 '+caseValue.ContactId);
        Hire_Form__c hireValue = hireMap.get(caseValue.ContactId);
        System.debug('123 '+hireValue);
        if(hireValue.Candidate__c == caseValue.ContactId  && !hireValue.Status__c.equals('Completed') && caseValue.Status.equals('Closed')){
            caseValue.Status.addError('You can not close the case until hire form  is completed');
        }
    }*/
    }