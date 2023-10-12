public class DailyRecordCountClass {
    public Integer getAccountCount(){
        return [SELECT Id, Name, ParentId, Phone, Email__c FROM Account where CreatedDate =Today].size(); 
    }
    public Integer getContactCount(){
        return [Select Id,Name, AccountId from Contact where createdDate=Today].size();
    }
    public Integer getOpportunityCount(){
        return [SELECT Id, Name, AccountId FROM Opportunity where CreatedDate =today].size();
    }
    public void sendEmail()
    {
        Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
        singleEmailMessage.setToAddresses(new List<String>{'Priyanshusirohi12@gmail.com'});
        singleEmailMessage.setSubject('Hi Priyanshu');
        String message ='<b>Total Today\'s Account Count : </b>'+getAccountCount();
        message += '<br/> <b>Total Today\'s Contact Count : </b>'+getContactCount();
        message += '<br/> <b>Total Today\'s Opportunity Count : </b>'+getOpportunityCount();
        message += '<br/> <b>Thank you</b>';
        singleEmailMessage.setHtmlBody(message);
        List<Messaging.Email> emails= new List<Messaging.Email>{singleEmailMessage};
        Messaging.SendEmailResult[] result = Messaging.sendEmail(emails);
        if(result[0].success){
            System.debug('Total Account : '+getAccountCount());
            System.debug('Total Contact : '+getContactCount());
            System.debug('Total Opportunity : '+getOpportunityCount());
        }else{
            System.debug('Error : '+result[0].errors[0].message);
        }
    }
}