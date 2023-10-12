public class StudentController {
    public List <Student__c> studentList{get;set;}
    public Student__c Student{get;set;}
    public String searchFirstName{get;set;}
    public String searchLastName{get;set;}
    public String searchCourse{get;set;}
    
    public StudentController()
    {
        studentList =new List<student__c>();
        studentList=[SELECT Id, Name, Last_Name__c, Email__c, Contact__c, Gender__c, Address__c, Age__c, Course__c FROM Student__c];
		Student =new Student__c();    	
    }
    public void multipleSearch()
    {   
      String query='SELECT Id, Name, Last_Name__c, Email__c, Contact__c, Gender__c, Address__c, Age__c, Course__c FROM Student__c where id != null ';
      System.debug(searchCourse);
        System.debug(searchCourse);
        System.debug(searchCourse);
        if(searchFirstName != null)
      {
          System.debug(searchFirstName);
          query += 'and Name like \'%'+searchFirstName+'%\' ';
      }
        
       if(searchLastName != null)
        {
            System.debug(searchLastName);
          query += 'and Last_Name__c like \'%'+searchLastName+'%\' ';  
        }
       if(Student.Course__c != null)
       {
           String searchCourse = Student.Course__c;
          // System.debug(Student.Course__c);
           query += 'and Course__c =: searchCourse';
           //System.debug(searchPhone);
       }
        System.debug(query);
        studentList = database.query(query);
    }
    public void showRecord()
    {
        studentList=[SELECT Id, Name, Last_Name__c, Email__c, Contact__c, Gender__c, Address__c, Age__c, Course__c FROM Student__c];
    }

}