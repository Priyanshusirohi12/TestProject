public class StudentCheckboxWithActionController {
        public List<StudentWrapperClass> studentDataList{get;set;} 
        public Boolean checkAll{get;set;}
        public List<Student__c> deleteRecords;
        public List<Student__c>addRecords;
        public Integer takeIndexOf{get;set;}
    	    
        /*------------Constroctor--------------*/
    
        public StudentCheckboxWithActionController(){
            studentDataList= new List<StudentWrapperClass>();
            deleteRecords= new List<Student__c>();
            addRecords = new List<Student__c>();
            for( Student__c stu : [SELECT Id, Name, Last_Name__c, Email__c, Contact__c,Gender__c, Married_Status__c, Husband_Name__c, Wife_Name__c FROM Student__c]){
                StudentWrapperClass StudentWrapperClassObject = new StudentWrapperClass();
                StudentWrapperClassObject.student=stu;
                studentDataList.add(StudentWrapperClassObject);
            }
        }
        /*------------To select all checkboxes and remove------------------------*/
        
        public void selectAllCheckbox(){//setCheckAll
            if(checkAll == true){    
                for(StudentWrapperClass stuDtls :  studentDataList){
                    stuDtls.isCheckStudent=true;
                }   
            }else if(checkAll == false){
                for(StudentWrapperClass stuDtls : studentDataList){
                    stuDtls.isCheckStudent=false;
                }
            }
        }
        /*------------To remove selected checkbox and select removed one------------------------*/
        
        public void changeCheckboxValue(){ //changeValue
            checkAll=true; 
            for(StudentWrapperClass stuDtls :  studentDataList){ 
               if(!stuDtls.isCheckStudent){
                   checkAll=false;
               }        
        	}
        }
        /*------------TO delete records------------------------*/
        
        public void deleteRecords(){
                /*studentId=studentDataList[takeIndexOf-1].student.id;*/
              
            StudentWrapperClass deleteObject = studentDataList.remove(takeIndexOf -1);
            if(deleteObject != null){
                deleteRecords.add(deleteObject.student);
            }
        }
        /*------------ToSave whole List------------------------*/
        
        public void saveRecords(){
            for(StudentWrapperClass StudentDtls :studentDataList){
                if(studentdtls.isCheckStudent){
                    addRecords.clear();
                    addRecords.add(studentDtls.student);
                    if(String.isBlank(studentDtls.student.Last_Name__c)){
                        studentDtls.isCheckStudent = true;
                    }
                    else{
                        studentDtls.isCheckStudent = false;
                    }
                }
            }
            try{
                if(addRecords.size() >0){
                    upsert addRecords;
                    //addRecords.clear();
                }
                if(deleteRecords.size() > 0){
                    delete deleteRecords;
                    //deleteRecords.clear();
                }
                } catch(DmlException e){
                	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Required Field Missing');
                	//ApexPages.addMessage(myMsg);
            	}  
        }
        /*------------Add empty records------------------------*/
        
        public void addNewRecords(){
            StudentWrapperClass studentRecord= new StudentWrapperClass();
            studentRecord.student =new Student__c();
            if(studentDataList.size() != takeIndexOf){
                studentDataList.add(takeIndexOf , studentRecord);
            }
            else if(studentDataList.size() == takeIndexOf){
                studentDataList.add(studentRecord);
            }
            studentRecord.isCheckStudent=true;
        }
        public class StudentWrapperClass{
            public Student__c student{get;set;}
            public Boolean isCheckStudent{get;set;}
            public StudentWrapperClass(){
            isCheckStudent=false;    
            }
        } 
    }