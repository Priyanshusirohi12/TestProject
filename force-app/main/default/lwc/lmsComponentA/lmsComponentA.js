import { LightningElement, wire } from 'lwc';
import SAMPLEMC from "@salesforce/messageChannel/MyMessageChannel__c"
import {MessageContext, publish} from 'lightning/messageService' 
export default class lmsComponentA extends LightningElement {
    inputValue;

    @wire(MessageContext)
    context
    
    inputHandler(event){
        this.inputValue = event.target.value;
    }

    publishMessage()
    {
        const message = {
            lmsData : {
                value : this.inputValue
            }
        }
        publish(this.context, SAMPLEMC, message);
    }
}