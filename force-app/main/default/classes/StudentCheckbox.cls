public class  StudentCheckbox{
    public List<Student__c> studentList{get;set;}
    public List<StudentWrapperClass> studentDataList{get;set;} 
    public List<StudentWrapperClass> fillStudentDataList{get;set;}
    //StudentWrapperClass studentWrapperObject;
    public boolean checkAll{get;set;}
    
	public StudentCheckbox(){
        checkAll=false;
        studentList=[SELECT Id, Name, Gender__c, Email__c, Last_Name__c FROM Student__c];
        studentDataList= new List<StudentWrapperClass>();
        fillStudentDataList= new List<StudentWrapperClass>();
        StudentWrapperClass studentWrapperObject;
        for( Student__c stu : studentList){
             studentWrapperObject = new StudentWrapperClass();
            studentWrapperObject.student=stu;
            studentDataList.add(studentWrapperObject);
        }
    }
    public void fillTable(){
        fillStudentDataList.clear();
        for(StudentWrapperClass stuDtls :  studentDataList)
        {
            if(stuDtls.isCheckStudent){
                fillStudentDataList.add(stuDtls);
            }
        }
    }
    public void setAllCheckBoxSelected(){
       for(StudentWrapperClass stuDtls :  studentDataList){
         if(checkAll =true){
             stuDtls.isCheckStudent=true;
         }
       }
    }
    public void setUnselectHearderCheckbox()
    {
        checkAll=true; 
        for(StudentWrapperClass stuDtls :  studentDataList){ 
           if(!stuDtls.isCheckStudent){
               checkAll=false;
           }        
    }
    }
    public class StudentWrapperClass{
        public Student__c student{get;set;}
        public Boolean isCheckStudent{get;set;}
        public StudentWrapperClass(){
        	IsCheckStudent=false;    
        }
    } 
}