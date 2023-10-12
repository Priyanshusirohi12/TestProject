public class StudentControler {
   //public Student__c Student{get;set;}
    public List<Student__c> StudentList{get;set;}
    public String searchName{get;set;}
    public String searchEmail{get;set;}
    public String searchPhone{get;set;}
    public StudentControler(){
        //Student = new Student__c();
    	 StudentList=new List<Student__c>();          
         studentQuery();     
    }   
    public void multipleSearch(){   
      String query='SELECT Id, Name, Last_Name__c, Email__c, Contact__c, Gender__c, Address__c, Age__c, Course__c FROM Student__c where id != null ';
      if(!searchName.equals('')){
          query += ' and Name like \'%'+searchName+'%\' ';
      }
       if(!searchEmail.equals('')){
          query += ' and Email__c like \'%'+searchEmail+'%\' ';  
        }
       if(!searchPhone.equals('')){
           query += ' and Contact__c like \'%'+searchPhone+'%\' ';
           //System.debug(searchPhone);
       }
        if(!String.isBlank(query)){
        		StudentList = database.query(query);
        }
        else{
            studentQuery();
        }
        
    }
    /*public void showRecord()
    {
        studentQuery();
    }*/
    public void studentQuery(){
        StudentList=[SELECT Id, Name, Last_Name__c, Email__c, Contact__c, Gender__c, Address__c, Age__c, Course__c FROM Student__c];
        
    }
}