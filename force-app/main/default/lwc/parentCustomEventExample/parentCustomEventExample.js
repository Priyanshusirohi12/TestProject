import { LightningElement } from 'lwc';

export default class ParentCustomEventExample extends LightningElement {
    id;
    name;
    studentDetails={};
    handelSimpleEvent(event){
        console.log("12323 "+JSON.stringify(event.detail));
        this.id = event.detail.id;
        this.name =event.detail.name;
        this.studentDetails ={
            email : event.detail.email,
            contact : event.detail.contact
        };
    }
}