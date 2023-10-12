import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
export default class StudentObjectDetails extends LightningElement {
    @api recordId;
    objectRecords ={};
    @wire(getRecord, {
        recordId : '$recordId',
        fields : ['Project__c.Name']
        
    })details({error, data}){
        if(data){
            this.objectRecords= {
                Name: data.fields.Name.value,
                //LastName : data.fields.Last_Name__c.value,
                //Email : data.fields.Email__c.value
            }
            //console.log('@@ '+JSON.stringify(data))
        }
        else{
            //console.log('## '+error);
        }
    }
}