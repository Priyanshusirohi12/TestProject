trigger HireFormTrigger on Hire_Form__c (before insert, After Update) {
    if(Trigger.isInsert){
        for(Hire_Form__c hireForm : Trigger.new){
            if(Trigger.isInsert){
                hireForm.Status__c ='In Progress';
            }
        }
    }
    if(Trigger.isAfter){
        	set<Id> contactId = new Set<Id>();
        	Map<Id,Hire_Form__c> hireMap = new Map<Id,Hire_Form__c>();//Trigger.newMap;
        	Boolean check =false;
        for(Hire_Form__c hireForm : Trigger.newMap.values()){
            	//hireMap.put(hireForm.Candidate__c,hireForm);
            if(hireForm.Status__c.equals('Completed')){
                contactId.add(hireForm.Candidate__c);
                //check= true;
            }
            System.debug('123456 '+hireForm.Candidate__c);
        }
             List<Case >caseList =[SELECT Id, Priority, ContactId, ParentId, Origin, Status FROM Case where ContactId =: contactId];
            for(Case caseRecords : caseList){
                caseRecords.Status='Closed';
            }
            if(Constants.UpsertBreak){
                Constants.UpsertBreak= false;
                Upsert caseList;
            }
       /* if(!check){ 
        	
           	List <Case>caseList2= [SELECT Id, Priority, ContactId, ParentId, Origin, Status FROM Case where ContactId =: hireMap.keySet()];
            for(Case caseRecord : caseList2){
                System.debug('gfggf '+caseRecord.ContactId);
                Hire_Form__c hireForm = hireMap.get(caseRecord.ContactId);
                System.debug('df '+hireForm);
                if(!(hireForm.Status__c.equals('Completed')) && caseRecord.Status.equals('Closed')){
                   //caseRecord.Status='Working';
                   caseRecord.Status.addError('Course Fees id empty Fill it');
                }
            }
            if(Constants.UpsertBreak){
                Constants.UpsertBreak= false;
                Upsert caseList2;
            }
        }
            
     }*/
	}
}