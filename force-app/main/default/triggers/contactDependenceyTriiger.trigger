trigger contactDependenceyTriiger on Contact (before insert, before update) {
    for(Contact contactObj : Trigger.new){
        if(contactObj.Designation__c == 'Clerk' && !(contactObj.Salary__c >=5000 && contactObj.Salary__c<=15000)){
                contactObj.Salary__c.addError('Salary is not valid for clerk');
        }
        if(contactObj.Designation__c == 'Manager' && !(contactObj.Salary__c >=12000 && contactObj.Salary__c<=50000)){
        	contactObj.Salary__c.addError('Salary is not valid for Manager');    
        }
           if(contactObj.Designation__c =='Accountant' && !(contactObj.Salary__c >=10000 && contactObj.Salary__c<=30000)){
               contactObj.Salary__c.addError('Salary in not valid for Accountant');
           }
    }
}