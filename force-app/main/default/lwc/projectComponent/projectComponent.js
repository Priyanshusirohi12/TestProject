import { LightningElement, api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
//const FIELDS =['Project__c.Name', 'Project__c.State__c'];
export default class ProjectComponent extends LightningElement {
    @api recordId;
    status;
    name;
    @wire(getRecord, {
        recordId: '$recordId',
        fields : ['Project__c.Name', 'Project__c.Status__c']
    })projectDetails({error,data}){
        if(error){
            console.log('Error');
        }else if(data){
            console.log('data '+JSON.stringify(data));
            this.name = data.fields.Name.value;
            this.status = data.fields.Status__c.value;
            console.log('name '+this.name);
            console.log('status '+this.status);
        }
    }

}