import { LightningElement, wire } from 'lwc';
import getRecordById from '@salesforce/apex/ContactController.getRecordById';
export default class RecordIdDetailsWithApex extends LightningElement {
    contactDetail ={};
    @wire(getRecordById , {id : '0035g000003C0MsAAK'}) 
    contact({error,data}){
        if(data){
            console.log('@@@@ '+JSON.stringify(data));
            this.contactDetail = data;
        }else{
            console.log('1234' +error);
        }
    }
}