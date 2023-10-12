import { LightningElement, wire } from 'lwc';
import showCustomer from '@salesforce/apex/HotalCustomerController.showCustomer';
import fatchRecord from '@salesforce/apex/HotalCustomerController.fatchRecord';
import updateRecord from '@salesforce/apex/HotalCustomerController.updateRecord';
export default class StudentDetails extends LightningElement {
    customerDetails;
    status;
    disable;
    customerId;
    customerRecord;
    fisrtName;
    lastName;
    email;
    city;
    isMarried;
    gender;
    phone;
    checkId;
    constructor(){
        super();
        this.status =false;
    }
    @wire(showCustomer)
    contacts ({error,data}){
        if(data){
            this.customerDetails =data;
            console.log('!234 '+JSON.stringify(data));
        }else{
            console.log('12 '+JSON.stringify(error));
        }
    }
    get genderRadio(){
        return [
            {label: 'Male', value : 'Male'},
            {label : 'Female' , value : 'Female'}
        ]; 
    }
    get cityList(){
        return [{label : 'Ajmer' , value : 'Ajmer'},
                {label : 'Jaipur' , value : 'Jaipur'},
                {label : 'Kota' , value : 'Kota'},
                {label : 'Udaipur' , value : 'Udaipur'},
                {label : 'Jothpur' , value : 'Jothpur'}
            ];
    }
    get isMarriedList(){
        return [
            {label : 'Married' , value : 'Married'},
            {label : 'Unmarried', value : 'UnMarried'}
        ]
    }
   
    handleIdOnEdit(event){
        this.status = true;
        this.disable =false;
        this.customerId = event.target.value;
        this.checkId = event.target.label;
        fatchRecord({id : this.customerId}).then(result=>{
            this.customerRecord = result;
            this.fisrtName = this.customerRecord.First_Name__c;
            this.lastName = this.customerRecord.Last_Name__c;
            this.isMarried = this.customerRecord.Is_Married__c;
            this.email = this.customerRecord.Email__c;
            this.city = this.customerRecord.City__c;
            this.gender = this.customerRecord.Gender__c;
            this.phone = this.customerRecord.Phone__c;
        }).catch(error=>{
            console.log('!! '+JSON.stringify(error));
        });   
    }

    handleIdOnView(event){
        this.status = true;
        this.disable =true;
        this.customerId = event.target.value;
        fatchRecord({id : this.customerId}).then(result=>{
            this.customerRecord = result;
            this.fisrtName = this.customerRecord.First_Name__c;
            this.lastName = this.customerRecord.Last_Name__c;
            this.isMarried = this.customerRecord.Is_Married__c;
            this.email = this.customerRecord.Email__c;
            this.city = this.customerRecord.City__c;
            this.gender = this.customerRecord.Gender__c;
            this.phone = this.customerRecord.Phone__c;       
        }).catch(error=>{
            console.log('!! '+JSON.stringify(error));
        });   
    }

    backButton(){
        this.status =  false;
    }
    SaveButton(){
        this.status = false;
        const customerData = this.template.querySelectorAll(".customer");
       const customerObj = {
           Id   :   this.customerId,
           First_Name__c :   customerData[0].value,
           Is_Married__c : customerData[1].value,
           Last_Name__c : customerData[2].value,
           Gender__c : customerData[3].value,
           City__c : customerData[4].value, 
           Phone__c : customerData[5].value,
           Email__c : customerData[6].value      
       };
       updateRecord({customer : customerObj, label : this.checkId}).then(result=>{
           console.log('12333 ' +JSON.stringify(result));
       }).catch(error=>{
        console.log('!! '+JSON.stringify(error));
       });
    }

    deleteOnClick(event){
        this.customerId =event.target.value;
        fatchRecord({id : this.customerId}).then(result=>{
            this.customerRecord = result;    
            console.log('!!@! '+JSON.stringify(this.customerRecord));
        }).catch(error=>{
            console.log('!! '+JSON.stringify(error));
        });   
        deleteRecord({customer : this.customerRecord}).then(result=>{
            console.log('hye '+JSON.stringify(result));
        }).catch(error=>{
            console.log('hi '+JSON.stringify(error));
        });
        }
        
        copyOnClick(event){
            this.checkId = event.target.label;
            console.log('leleleel '+this.checkId);
            this.status = true;
            this.disable =false;
            this.customerId = event.target.value;
            console.log('## '+JSON.stringify(this.customerId)); 
            fatchRecord({id : this.customerId}).then(result=>{
                console.log('####### '+JSON.stringify(result));
                this.customerRecord =result;
                this.fisrtName = this.customerRecord.First_Name__c;
                this.lastName = this.customerRecord.Last_Name__c;
                this.isMarried = this.customerRecord.Is_Married__c;
                this.email = this.customerRecord.Email__c;
                this.city = this.customerRecord.City__c;
                this.gender = this.customerRecord.Gender__c;
                this.phone = this.customerRecord.Phone__c; 
            }).catch(error=>{
                console.log('### '+JSON.stringify(error)); 
            });
        }
}