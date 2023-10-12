public class StudentCustomController {
    public List<Student__c> studentList {get;set;}
    public Student__c student {get;set;}
    public Id id;
    public StudentCustomController(){
        studentList =[Select Id, Name ,Last_Name__c , Email__c from Student__c];
        id = ApexPages.currentPage().getParameters().get('id');
        if(id !=null){
            student =[Select id,Name,Last_Name__c,Email__c from Student__c where Id =: id];
        }else if(id == null){
            student = new Student__c();
        }
    }
    public void save(){
        if(id != null){
            update student;
        }else if(id == null){
            insert student;
        }
    }
}