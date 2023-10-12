import { LightningElement } from 'lwc';

export default class OnButtonClickEventCompondent extends LightningElement {
   name="Priyanshu";
    nameValue;
    changeHeand(event){
        this.nameValue=event.target.value;
    }
    clickHeand(event){
        alert('Hello World');
        this.name=this.nameValue;
    }
}