import { LightningElement, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import STUDENT_OBJ from '@salesforce/schema/Student__c';
export default class StaticObjectListExample extends LightningElement {
    
    studentDetails;

    @wire(getListUi , {
            objectApiName : STUDENT_OBJ 
         })
    studentList({error , data}){
       if(data){
           //this.studentDetails = data.records.records;  
           // console.log("Name : "+data.records.records[0].fields.Name.value);   
            //console.log('rohanp '+JSON.stringify(data));
           // console.log('@@@ '+JSON.stringify(this.studentDetails));
       }else{
           //console.log('anil '+error);
          
            
        }
    }

        //00B5g00000808qgEAA

        @wire(getListUi , {
            listViewId : '00B5g00000808qgEAA' 
         })student({error,data}){
             if(data){
                this.studentDetails = data.records.records;
                // console.log('-----'+JSON.stringify(data));
                 //console.log('___+++'+JSON.stringify(this.studentDetails))
                 console.log('Priyanshu '+student.fields.Last_Name__c.value);
                 console.log('Naman '+student.fields.Email__c.value);
             }
             else{
                 console.log('+++++'+JSON.stringify(error));
             }
         }
         
        
    


}