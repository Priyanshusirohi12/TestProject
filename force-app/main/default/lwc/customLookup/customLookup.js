import { LightningElement } from 'lwc';
export default class CustomLookup extends LightningElement {
    fields = ["Name","Email","Phone"];
    displayFields = 'Name, Email, Phone'

    handleLookup(event){
        console.log( JSON.stringify ( event.detail) )
    }
}