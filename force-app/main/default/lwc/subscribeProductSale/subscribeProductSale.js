import { LightningElement,wire,track } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, fireEvent,unregisterAllListeners} from 'c/pubSub';
export default class SubscribeProductSale extends LightningElement {
    
    @track getRecords=[] ;
    @track totalAmount=0;
    @wire(CurrentPageReference) pageRef;
    connectedCallback(){
        registerListener("fatchDetails",this.fatchDetails,this);
    }
    fatchDetails(data){
        console.log('hello '+JSON.stringify(data));

        this.getRecords.push(data);
        this.totalAmount = this.totalAmount + parseInt(data.price);
        //this.getRecords  =  this.getRecords + data;
        console.log('hello2 '+JSON.stringify(this.getRecords));
    }
}