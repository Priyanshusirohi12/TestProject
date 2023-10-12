public class SendEmailToStudentController {
    public List <StudentWrapperClass> studentWrapperList {get;set;} 
    public Boolean checkAll {get;set;} 
    public Boolean addAttachment {get;set;}
    public String studentEmail {get;set;}
    public String subject {get;set;}
    public String body {get;set;} 
    set<Id> studentId;
    public SendEmailToStudentController(){
        studentWrapperList = new List<StudentWrapperClass>();
        studentId = new set<Id>();
        for(Student__c student : [Select Id, Name, Contact__c, Email__c from Student__c]){
            StudentWrapperList.add(new StudentWrapperClass(student,false));
        }
    }
    public void selectAll(){
        studentEmail ='';
        for(StudentWrapperClass student : studentWrapperList){
                if(checkAll && !String.isBlank(student.studentObject.Email__c) && !studentEmail.contains(student.studentObject.Email__c)){
                    student.check =true; 
                    studentId.add(student.studentObject.Id);
                    if(!String.isBlank(studentEmail)){
                        studentEmail = studentEmail + ', ';
                    }
                    studentEmail = studentEmail + student.studentObject.Email__c;
            	}
            else if(!checkAll){
                student.check=false;
                studentEmail='';
            }
        }  
   	}
    public void selectOneCheckBox(){
        checkAll = true;
        studentEmail ='';
        for(studentWrapperClass wrapperObject : studentWrapperList){
            if(!wrapperObject.check){
                checkAll = false; 
            }
                if(wrapperObject.check && !String.isBlank(wrapperObject.studentObject.Email__c) && !studentEmail.contains(wrapperObject.studentObject.Email__c)){
                    studentId.add(wrapperObject.studentObject.Id);
                    if(!studentEmail.equals('')){
                        studentEmail = studentEmail + ', ';
                    }  
                     studentEmail = studentEmail + wrapperObject.studentObject.Email__c;
                }
        }
    }
      public pageReference sendMail(){
           Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
           Messaging.EmailFileAttachment[] attachments;   
           if(addAttachment){
                for(Attachment attach : [SELECT Id, ParentId, Name, ContentType, Body FROM Attachment where ParentId =: studentId AND ContentType Like '%image%' limit 1	]){
                	Messaging.EmailFileAttachment emailFileAttachment = new Messaging.EmailFileAttachment();
                    emailFileAttachment.setFileName(attach.Name);
                    emailFileAttachment.setBody(attach.Body);
                    attachments = new Messaging.EmailFileAttachment[]{emailFileAttachment};    	
                  }
              }
          for(studentWrapperClass wrapperObject : studentWrapperList){
              if(checkAll){
                if(!String.isBlank(wrapperObject.studentObject.Email__c)){
                    singleEmailMessage.setToAddresses(new String[]{wrapperObject.studentObject.Email__c});        
                }
                if(!String.isBlank(subject)){
                    singleEmailMessage.setSubject(subject);  
                }
                if(!String.isBlank(body)){
                    singleEmailMessage.setHtmlBody(body);   
                }
                singleEmailMessage.setFileAttachments(attachments);
                Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.Email[]{singleEmailMessage});
             	if(result[0].success){
             		System.debug('email send successfully');
          	   	} else {
                	System.debug('Error : '+result[0].errors[0].message);
             	}
            }
            if(wrapperObject.check){
                if(!String.isBlank(wrapperObject.studentObject.Email__c)){
                    singleEmailMessage.setToAddresses(new String[]{wrapperObject.studentObject.Email__c});        
                }
                if(!String.isBlank(subject)){
                    singleEmailMessage.setSubject(subject);  
                }
                if(!String.isBlank(body)){
                    singleEmailMessage.setHtmlBody(body);   
                }
                singleEmailMessage.setFileAttachments(attachments);
            }
          }
          Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.Email[]{singleEmailMessage});
             if(result[0].success){
             	System.debug('email send successfully');
             } else {
                System.debug('Error : '+result[0].errors[0].message);
             }
          pageReference pg = new pageReference('/apex/send_email_to_student_page');
          pg.setRedirect(true);
          return pg;
     }
     public class StudentWrapperClass{
        public Student__c studentObject {get;set;}
        public Boolean check {get;set;}
        StudentWrapperClass(Student__c studentObject, Boolean check){
            this.studentObject =studentObject;
            this.check =check;
        }      
    }
}