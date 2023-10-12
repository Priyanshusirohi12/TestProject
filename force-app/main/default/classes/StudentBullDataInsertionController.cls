public class StudentBullDataInsertionController {
    public List<Student__c> studentList{get;set;}
    List<Student__c> tempStudentList;
    
    public String Course{get;set;}
   	public StudentBullDataInsertionController()  {
        studentList =new List<Student__c>();
        tempStudentList = new List<Student__c>();
  		loop();
    }
    public void loop(){
         for(Integer i=0;i<=2;i++){
            studentList.add(new Student__c());
        }
    }
    public PageReference multipleInsertion(){
    	for(Student__c stu : studentList){
         	 
            if(!String.isBlank(stu.Last_Name__c)){
                	System.debug('Hte');
                	tempStudentList.add(stu);    
                }
        }
        if(tempStudentList.size()>0){
        insert tempStudentList;
        PageReference pgInsert =new PageReference('/a01/o');
        pgInsert.setRedirect(true);
        return pgInsert;
        }
        else{
            System.debug('hye');
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Insert At Least On Record'));
     		//ApexPages.addMessage(myMsg);
     		return null;   
        } 
    }
    public PageReference clearAllValues(){
        PageReference pgClear;
        pgClear= new PageReference('/a01/o');
        pgClear.setRedirect(true);
        return pgClear;
    }
}