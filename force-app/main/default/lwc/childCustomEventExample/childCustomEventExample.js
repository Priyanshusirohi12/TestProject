import { LightningElement } from 'lwc';

export default class ChildCustomEventExample extends LightningElement {
    handleOnButton(){
        const recordData = this.template.querySelectorAll(".record");
        const fillStudentObject = {
            id : recordData[0].value,
            name : recordData[1].value,
            email : recordData[2].value,
            contact : recordData[3].value,
        };
        console.log("fsgfdgd "+JSON.stringify(fillStudentObject));
        const customEvent = CustomEvent('simpleevent',{
            detail : fillStudentObject
        });
        this.dispatchEvent(customEvent);
    }
}