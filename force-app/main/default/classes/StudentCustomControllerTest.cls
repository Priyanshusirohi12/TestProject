@isTest
public class StudentCustomControllerTest {
	@isTest
    public static void getStudent(){
        StudentCustomController studentCustomController = new StudentCustomController();
        List<Student__c> studentList= studentCustomController.studentList;
        Integer size = studentList.size();
     	System.assert(size != 0,'Size '+size);   
    }
    @isTest
    public static void getStudentData(){
        Student__c student = new Student__c(Last_Name__c = 'test 1');
        Test.startTest();
        insert student;
        Test.stopTest();
        System.assert(student.Id != null);
        StudentCustomController studentCustomController = new StudentCustomController();
        List<Student__c> studentList=  studentCustomController.studentList;
        System.assertEquals('test 1', studentList.get(0).Last_Name__c);  
    }
    //@isTest
    public static testMethod void addStudentWithoutRequiredField(){
		StudentCustomController studentCustomController = new StudentCustomController();
        studentCustomController.save();
        System.assert(studentCustomController.student.id != null, 'is is '+studentCustomController.student.id != null);
    } 
    public static testMethod void addStudent(){
        StudentCustomController studentCustomController = new StudentCustomController();
        studentCustomController.student.Last_Name__c ='Test 2';
        studentCustomController.save();  
    }

	@isTest
    public static void updateStudent(){
        Student__c student = new Student__c(Last_Name__c = 'test 1');
        Test.startTest();
        insert student;
        Test.stopTest();
        System.assert(student.Id != Null);
        
        ApexPages.CurrentPage().getParameters().put('id',student.Id);
        StudentCustomController studentCustomController = new StudentCustomController();
        System.assert(studentCustomController.Id != Null);
		studentCustomController.student.Email__c ='test@gmail.com';
        studentCustomController.save();
    }
}