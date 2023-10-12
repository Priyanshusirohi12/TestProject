import { LightningElement, api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
export default class DynamicObjectRecords extends LightningElement {
    @api recordId;
    objectRecords;
    @api objectApiName;

    @wire(getRecord,{
        recordId : '$recordId',
        objectApiName : '$objectApiName'
        })
        sObjectList({error, data}){
            if(data){
                //this.objectRecords= data.fields;
                console.log('123456 '+JSON.stringify(data));
                //console.log('222 '+JSON.stringify(this.recordId));
                //console.log('113 '+JSON.stringify(this.objectRecords));
            }else{
                console.log('sirohi144 '+error)
            }
        }
    /*@wire(getRecord, {
       recordId : '$recordId', 
       fields : '$fieldsFormated' 
    })records(data){
        console.log('HYE');
        console.log('@@@ '+data);
        objRecords={
            RecordIds : data.recordId,
            
        };

    }*/
}