public without sharing class NewSendEmailController {
    
    public static void sendBulkEmail(){
        EmailTemplate et = [SELECT Id, Body, Subject  FROM EmailTemplate WHERE DeveloperName = 'Form_Email_Template'];
        List<Email_Customer__c> emailCustomerList = [SELECT Id, Email__c, Is_Email_Send__c, Name 
                                             FROM Email_Customer__c 
                                             ];
    List<string> toAddress = new List<string>();
    List<Messaging.SingleEmailMessage> singleEmailMessageList = new List<Messaging.SingleEmailMessage>(); 
    for(Contact e : [SELECT Id,Email, Name 
                               FROM Contact  
                               WHERE Id = '0035g00000tlisLAAQ']){
   		Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
        singleEmailMessage.setTemplateId(et.Id);
        //singleEmailMessage.setToAddresses(new List<string>{e.Email});
        singleEmailMessage.setTargetObjectId(e.Id);
        //singleEmailMessage.setWhatId(e.Id);
        singleEmailMessage.setSaveAsActivity(false);
        singleEmailMessage.setUseSignature(false);
        singleEmailMessageList.add(singleEmailMessage); 
        System.debug('singleEmailMessage '+singleEmailMessage);
    
        
    }
   	//try {
        Messaging.sendEmail(singleEmailMessageList);
        return;
    /*} catch (Exception exp) {
        System.debug(exp.getMessage());
    }*/
    /*toAddress.add(primaryEmail);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(et.Id);
        mail.setToAddresses(toAddress);
        mail.setSubject('test subject');
        mail.setTargetObjectId(primaryContact);
        mail.setWhatId(primaryAccount);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
    allmsg.add(mail);*/
    
    
    }
}