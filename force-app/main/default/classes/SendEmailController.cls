public class SendEmailController {
    public String emailValue {get;set;}
   	public String ccEmail {get;set;}
    public String bccEmail {get;set;}
    public String subject {get;set;}
    public String body {get;set;}
    public Boolean check {get;set;}
    public SendEmailController(){
   
    }
    public void checkValue(){
        System.debug('hye');
    }
    
    public PageReference sendMail2(){
        Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
        if(!emailValue.equals('')){
            System.debug('11 '+emailValue);
        	singleEmailMessage.setToAddresses(new String[]{emailValue});
        }
        if(!ccEmail.equals('')){
            System.debug('22 '+ccEmail);
        	singleEmailMessage.setCcAddresses(new String[]{ccEmail});    
        }
        if(!bccEmail.equals('')){
            System.debug('22 '+bccEmail);
       		 singleEmailMessage.setBccAddresses(new String[]{bccEmail});     
        }
        // System.debug('22 '+subject);
        if(!subject.equals('')){
       		 singleEmailMessage.setSubject(subject);     
        }
        else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
   			 return null;
        }
        //String msg = '<b>Hi All</b><br/>Good Morning...';
        
        if(!body.equals('')){
            System.debug('22 '+body);
       		 singleEmailMessage.setHtmlBody(body);     
        }
                         
        Messaging.Email[] sendEmails = new Messaging.Email[]{singleEmailMessage};
        Messaging.SendEmailResult[] result = Messaging.sendEmail(sendEmails);
        if(result[0].success){
            System.debug('email send successfully');
        } else {
            System.debug('Error : '+result[0].errors[0].message);
        }
        PageReference pg = new PageReference('/apex/send_email_page');
        pg.setRedirect(true);
        return pg;
    }
}