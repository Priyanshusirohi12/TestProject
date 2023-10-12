import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
export default class ProjectTaskComponent extends LightningElement {
    @api recordId;
    type;
    name;
    @wire(getRecord, {
        recordId: '$recordId',
        fields : ['Project_Task__c.Name', 'Project_Task__c.Type__c']
    })projectDetails({error,data}){
        if(error){
            console.log('Error');
        }else if(data){
            console.log('data '+JSON.stringify(data));
            this.name = data.fields.Name.value;
            this.type = data.fields.Type__c.value;
            console.log('name '+this.name);
            console.log('status '+this.status);
        }
    }

}