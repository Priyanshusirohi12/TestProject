global class ReminderDateNotificationBatch implements Database.Batchable<SObject>, Database.Stateful {
  	public date dateValue;
    Exception[] errors = new Exception[0];
    //For email send 
    public Map<String,String> emailBodyMap;
    public Map<String, String> reminderEmailBodyMap;
    //public List<String> emailList;
    //For Bell notification
    public List<String> userRecordList;
    public Map<String, String> notificationMap;
    //public List<String> notificationList;
    public Map<String, String> notificationMessageMap;
    public Map<String, String> notificationRecordIdMap;
   
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //Email functinality
        emailBodyMap = new Map<String, String>();
        userRecordList = new List<String>();
        reminderEmailBodyMap = new Map<String, String>();
       	
        //Notification functinality
        notificationRecordIdMap = new Map<String, String>();
        notificationMap = new Map<String, String>();
        notificationMessageMap = new Map<String, String>();
        dateValue = System.today() - 10;
        System.debug('dateValue '+dateValue);
        return Database.getQueryLocator([SELECT Id, Name,OwnerId, Owner.Email,Investment_ID__c, Owner.Name, Account__r.Name, Reminder_Date__c
                                        FROM Stimulus_Deal__c
                                        WHERE Reminder_Date__c =: dateValue
                                        Or 
                                        Reminder_Date__c =: System.Today()]);
    }
    global void execute(Database.BatchableContext bc, List<Stimulus_Deal__c> stimulesDealList){
        
            System.debug('stimulesDealList '+stimulesDealList);
        
            
            String Body = '<table border="1" style="border-collapse: collapse"><tr><th>Owner Name</th><th>Account Name</th><th>Stimulus Deal Name</th><th>Record Link</th></tr>';
            String htmlBody = '';
            for(Stimulus_Deal__c stimulesDeal : stimulesDealList){
                System.debug('stimulesDeal '+stimulesDeal.owner.Name);
                
                	//Email Functionality
                	if(stimulesDeal.Reminder_Date__c == System.today()){
                   		if(!emailBodyMap.containsKey(stimulesDeal.Owner.Email)){
                            htmlBody = '<html><head></head><body><div>Hi '+stimulesDeal.Owner.Name+',</div><p>Please see pending manual adjustments under stimulus deals.</p>' + Body;
                            htmlBody += '<tr><td>'+stimulesDeal.Owner.Name+'</td><td>'+stimulesDeal.Account__r.Name+'</td><td>'+stimulesDeal.Name+'</td><td><a href="'+System.Label.orgUrl + stimulesDeal.Id +'">'+System.Label.orgUrl + stimulesDeal.Id+'</a></td></tr></table></html>';
                            emailBodyMap.put(stimulesDeal.Owner.Email, htmlBody);
                            htmlBody = '';
                        }else if(emailBodyMap.containsKey(stimulesDeal.Owner.Email)){
                            String oldEmailBody = emailBodyMap.get(stimulesDeal.Owner.Email);
                            String temp  ='<tr><td>'+stimulesDeal.Owner.Name+'</td><td>'+stimulesDeal.Account__r.Name+'</td><td>'+stimulesDeal.Name+'</td><td><a href="'+System.Label.orgUrl + stimulesDeal.Id +'">'+System.Label.orgUrl + stimulesDeal.Id+'</a></td></tr>';
                            String fullBody = addChar(oldEmailBody, temp , oldEmailBody.indexOf('</table>'));
                            emailBodyMap.put(stimulesDeal.Owner.Email, fullBody);  
                        }    
                	}else if(stimulesDeal.Reminder_Date__c == System.today() - 10){
                   		if(!reminderEmailBodyMap.containsKey(stimulesDeal.Owner.Email)){
                            htmlBody = '<html><head></head><body><div>Hi '+stimulesDeal.Owner.Name+',</div><p>Important action required</p><p>Please see pending manual adjustments under stimulus deals.</p>' + Body;
                            htmlBody += '<tr><td>'+stimulesDeal.Owner.Name+'</td><td>'+stimulesDeal.Account__r.Name+'</td><td>'+stimulesDeal.Name+'</td><td><a href="'+System.Label.orgUrl + stimulesDeal.Id +'">'+System.Label.orgUrl + stimulesDeal.Id+'</a></td></tr></table></html>';
                            reminderEmailBodyMap.put(stimulesDeal.Owner.Email, htmlBody);
                            htmlBody = '';
                        }else if(reminderEmailBodyMap.containsKey(stimulesDeal.Owner.Email)){
                            String oldEmailBody = reminderEmailBodyMap.get(stimulesDeal.Owner.Email);
                            String temp  ='<tr><td>'+stimulesDeal.Owner.Name+'</td><td>'+stimulesDeal.Account__r.Name+'</td><td>'+stimulesDeal.Name+'</td><td><a href="'+System.Label.orgUrl + stimulesDeal.Id +'">'+System.Label.orgUrl + stimulesDeal.Id+'</a></td></tr>';
                            String fullBody = addChar(oldEmailBody, temp , oldEmailBody.indexOf('</table>'));
                            reminderEmailBodyMap.put(stimulesDeal.Owner.Email, fullBody);  
                        }    
                	}
                
                	//Bell Notification Functionality
                	if(!notificationMap.containsKey(stimulesDeal.OwnerId)){
                        userRecordList.add(stimulesDeal.OwnerId+'-'+stimulesDeal.Owner.Email);
                        notificationRecordIdMap.put(stimulesDeal.OwnerId, stimulesDeal.Id);
                        notificationMessageMap.put(stimulesDeal.OwnerId, 'Hi '+stimulesDeal.Owner.Name+', Good morning you need to look into these records');
                       notificationMap.put(stimulesDeal.OwnerId, stimulesDeal.Name);  
                    }else if(notificationMap.containsKey(stimulesDeal.OwnerId)){
                    	String temp = notificationMap.get(stimulesDeal.OwnerId);
                        temp += ', '+stimulesDeal.Name;
                        notificationMap.put(stimulesDeal.OwnerId, temp);
                    }
            }        
           
    }
    
    
    global void finish(Database.BatchableContext BC){
        List<String> emailList = new List<String>();
        for(User user : [Select Email From User where Profile.Name = 'System Administrator']){
        	emailList.add(user.Email);    
        }
        if(errors.isEmpty()){
        	/*Database.executeBatch(new emailSendBatch(emailBodyMap, 
                                                     reminderEmailBodyMap,
                                                 emailList, 
                                                 notificationMap, 
                                                 notificationMessageMap, 
                                                 notificationRecordIdMap, 
                                                 notificationList), 1);*/
            System.debug('userRecordList '+userRecordList);
            Database.executeBatch(new emailSendBatch(emailBodyMap, 
                                                     reminderEmailBodyMap,
                                                 	notificationMap, 
                                                 	notificationMessageMap, 
                                                 	notificationRecordIdMap,
                                                    userRecordList), 1);
        }else if(!errors.isEmpty()) {
            System.debug('errors '+errors);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Errors occurred during batch process.');
            mail.setToAddresses(emailList);
            mail.setPlainTextBody('Exception: ' + errors[0].getTypeName() + ': ' + errors[0].getMessage() + ' -- on ReminderDateNotificationBatch Apex Class on line no '+errors[0].getStackTraceString());
            Messaging.sendEmail(new Messaging.Email[] { mail });
        }

          
    }
   
    public String addChar(String str, String ch, Integer position) {
    return str.substring(0, position) + ch + str.substring(position);
}
   
}