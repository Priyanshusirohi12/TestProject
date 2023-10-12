import { LightningElement,wire } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, fireEvent,unregisterAllListeners} from 'c/pubSub';
export default class Subscribe extends LightningElement {
    message;
    details={};
    @wire(CurrentPageReference) pageRef;

    connectedCallback(){
        registerListener("showMessage",this.showMessage,this);
        registerListener("showRecords",this.showRecords,this);
    }
    showMessage(message){
        this.message =message;
        console.log('dd '+message);
    }
    showRecords(data){
        this.details = data;
    }
    handleList(){
        var list ={
            Name : 'Naman Rao',
            Age : 17,
            Email :'Naman@gmail.com',
            Phone : 54545646
        }
        fireEvent(this.pageRef,"showList",list);
    }
    disconnectedCallback(){
        unregisterAllListeners(this);
    }
    
}