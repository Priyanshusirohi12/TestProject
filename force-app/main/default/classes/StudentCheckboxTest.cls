@isTest
public class StudentCheckboxTest {
	@testSetup
    public static void fillStudentList(){
        List <Student__c> studentList = new List<Student__c>();
        studentList.add(new Student__c(Name ='Priyanshu', Gender__c = 'Male', Email__c='Priyanshu@gmail.com', Last_Name__c='Sirohi'));
        studentList.add(new Student__c(Name='Himanshu', Gender__c ='Male', Email__c='Himanshu@gmail.com', Last_Name__c = 'Sen'));
        studentList.add(new Student__c(Name='Tarun', Gender__c ='Male', Email__c='Tarun@gmail.com', Last_Name__c = 'Mehra'));
        studentList.add(new Student__c(Name='Samiksha', Gender__c ='Male', Email__c='Samiksha@gmail.com', Last_Name__c = 'yadav'));
    	Test.startTest();
        INSERT studentList;
        Test.stopTest();
        StudentCheckbox  studentCheckbox = new StudentCheckbox();
        StudentCheckbox.StudentWrapperClass studentWrapperClass = new StudentCheckbox.StudentWrapperClass();
        System.debug(studentCheckbox.studentDataList.size());
        System.debug(studentCheckbox.fillStudentDataList.size());
    }
    @isTest
    public static void checkFillTable(){
    	StudentCheckbox studentCheckbox =  new StudentCheckbox();
        //studentCheckbox.StudentWrapperClass studentWrapperClass = new StudentCheckbox.StudentWrapperClass();
       //studentWrapperClass.isCheckStudent = true;
        studentCheckbox.fillTable(); 	
    }
    
   	@isTest
    public static void checkSetAllCheckBoxSelected(){
    	StudentCheckbox studentCheckbox = new StudentCheckbox();
        studentCheckbox.checkAll = true;
        studentCheckbox.setAllCheckBoxSelected();
    }
    
    @isTest
    public static void checkSetUnselectHearderCheckbox(){
        StudentCheckbox studentCheckbox = new StudentCheckbox();
        //studentCheckbox.StudentWrapperClass studentWrapperClass = new StudentCheckbox.StudentWrapperClass();
        //studentWrapperClass.isCheckStudent = false;
        studentCheckbox.setUnselectHearderCheckbox();
    }
}