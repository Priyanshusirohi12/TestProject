import { LightningElement, wire } from 'lwc';
import {fireEvent,registerListener,unregisterAllListeners} from 'c/pubSub';
import {CurrentPageReference} from 'lightning/navigation';
export default class Publisher extends LightningElement {
    list ={}
    @wire(CurrentPageReference) pageRef;
    handleClick(){
        fireEvent(this.pageRef,"showMessage","Hello All -Welcome in my world");
    }
    handleRecord(){
        var data= {
            Name: 'Priyanshu',
            FatherName: 'CS Sirohi',
            MotherName : 'Anita Sharma',
            Email: 'Priyanshusirohi12@gmail.com'
        }
        fireEvent(this.pageRef,"showRecords",data);
    }
    showList(data){
        this.list = data;
    }
    connectedCallback(){
        registerListener("showList",this.showList,this); 
    }
    disconnectedCallback(){
        unregisterAllListeners(this);
    }
}