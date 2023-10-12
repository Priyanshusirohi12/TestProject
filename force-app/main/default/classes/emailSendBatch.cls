global class emailSendBatch implements Database.Batchable<String>, Database.Stateful {
   
    Date dateValue = System.today() - 10;
    Exception[] errors = new Exception[0];
    public List<String> userRecordList;
    //Notification functionality 
    public CustomNotificationType notificationType;
    public Map<String, String> notificationMap;
    public Map<String, String> notificationMessageMap;
    public Map<String, String> notificationRecordIdMap;
    
    // send emails functionality
    public Map<String, String> emailBodyMap;
    public Map<String, String> reminderEmailBodyMap;
   
   
    public emailSendBatch(Map<String, String> emailBodyMap,
                          Map<String, String> reminderEmailBodyMap,
                           
                          Map<String, String> notificationMap, 
                          Map<String, String> notificationMessageMap, 
                          Map<String, String> notificationRecordIdMap,
                          List<String> userRecordList){
         
        //Email variable assign                     
    	this.emailBodyMap = emailBodyMap;
        this.userRecordList =  userRecordList;
        this.reminderEmailBodyMap = reminderEmailBodyMap; 
                              
       //Notification functionality 
        this.notificationMap = notificationMap;   
		this.notificationMessageMap = notificationMessageMap;
        this.notificationRecordIdMap = notificationRecordIdMap;              
    }
   
    global Iterable<String> start(Database.BatchableContext bc){
 
   		notificationType = [SELECT Id, DeveloperName
                           	FROM CustomNotificationType
                            WHERE DeveloperName='RemiderDateAlert'];
        return userRecordList;
    }
    
    global void execute(Database.BatchableContext bc, List<String> variableList){
        	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        	for(String userDetail : variableList){
                //Email notification 
                System.debug('userDetail '+userDetail);
                String userEmail = userDetail.split('-')[1];
                System.debug('userEmail 1'+userEmail);
                if(emailBodyMap.containsKey(userEmail)){
                	mails.add(setEmailMessage(emailBodyMap, userEmail));	 
                   
                }
                if(reminderEmailBodyMap.containsKey(userEmail)){
                	mails.add(setEmailMessage(reminderEmailBodyMap, userEmail));   
                }
                // Bellnotification
                String userId = userDetail.split('-')[0];
                System.debug('userId '+userId);
           		Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle(notificationMessageMap.get(userId));
                notification.setBody(notificationMap.get(userId));    
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(notificationRecordIdMap.get(userId));      
                notification.send(new Set<String>{userId});
            }
            
        	System.debug('mails 1 '+mails);
        	
            
           /*if(mails.size() > 0){
                System.debug('mails.size() '+mails.size());
               Messaging.SendEmailResult[] result = Messaging.sendEmail(mails);
                If(result[0].success){
                    System.debug('email send successfully');
                } else{
                    System.debug('Error : '+result[0].errors[0].message);
                }    
            }*/
            
         
            
             
    }   
    global void finish(Database.BatchableContext BC){
        List<String> emailList = new List<String>();
        for(User user : [Select Email From User where Profile.Name = 'System Administrator']){
        	emailList.add(user.Email);    
        }
        if(!errors.isEmpty()) {
            System.debug('errors '+errors);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Errors occurred during batch process.');
            mail.setToAddresses(emailList);
            mail.setPlainTextBody('Exception: ' + errors[0].getTypeName() + ': ' + errors[0].getMessage() + ' -- on emailSendBatch Apex Class on line no '+errors[0].getStackTraceString());
            Messaging.sendEmail(new Messaging.Email[] { mail });
        }else{
        	System.debug('Secound batch finish');
        }
    }
    
     //setting up email message
    public static Messaging.SingleEmailMessage setEmailMessage(Map<String, String> notificationMap, String email){
    	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new List<String>{email});
        message.setCcAddresses(new List<String>{'Priyanshusirohi12@gmail.com'});
        message.setSubject('User Alert');
        message.setHtmlBody(notificationMap.get(email)); 
        System.debug('email '+email);
        System.debug('notificationMap.get(email) '+notificationMap.get(email));
        return message;
    }
}