/**
 * Created by szheng on 2019-09-11.
 */

public class TC_ChangeOwnerCtrl {
    @auraEnabled
    public static void setOwnerId(ID recordId, Id userId){
        List<Opportunity> opps = new List<Opportunity>([SELECT Id, OwnerId FROM Opportunity WHERE Id =:recordId]);
        List<Contact> cont = new List<Contact>([SELECT Id, OwnerId FROM Contact WHERE Id =:recordId]);
        List<Account> acc = new List<Account>([SELECT Id, OwnerId FROM Account WHERE Id =:recordId]);
        List<Lead> leads = new List<Lead>([SELECT Id, OwnerId FROM Lead WHERE Id =:recordId]);
        if (opps.size() > 0){
            opps[0].OwnerId = userId;
            Database.update(opps);
        } else if (cont.size() > 0){
            cont[0].OwnerId = userId;
            Database.update(cont);
        } else if (acc.size() > 0){
            acc[0].OwnerId = userId;
            Database.update(acc);
        } else if (leads.size() > 0){
            leads[0].OwnerId = userId;
            Database.update(leads);
        } else {return;}
        List<Task> tasks = new List<Task>([SELECT Id, OwnerId FROM Task WHERE WhatId = :recordId AND Status ='Open']);
        List<Task> updatedTasks = new List<Task>();
        for (Task t : tasks) {
            t.OwnerId = userId;
            updatedTasks.add(t);
        }
        Database.update(updatedTasks);
    }
    @auraEnabled
    public static Opportunity getOpportunity(Id recordId){
        List<Opportunity> opps = new List<Opportunity>([SELECT Id,Name FROM Opportunity WHERE Id =:recordId]);
        if(opps.size() > 0){
            return opps[0];
        } else {return null;}
    }
    
    @auraEnabled 
   public static Contact getContact(Id recordId){
        List<Contact> cont = new List<Contact>([SELECT Id,Name FROM Contact WHERE Id =:recordId]);
        if(cont.size() > 0){
            return cont[0];
        } else {return null;}
    }
    @auraEnabled 
   public static Account getAccount(Id recordId){
        List<Account> acc = new List<Account>([SELECT Id,Name FROM Account WHERE Id =:recordId]);
        if(acc.size() > 0){
            return acc[0];
        } else {return null;}
    }
    @auraEnabled 
   public static Lead getLead(Id recordId){
        List<Lead> leads = new List<Lead>([SELECT Id,Name FROM Lead WHERE Id =:recordId]);
        if(leads.size() > 0){
            return leads[0];
        } else {return null;}
    }
}