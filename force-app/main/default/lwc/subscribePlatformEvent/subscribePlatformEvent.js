import {LightningElement, wire, api, track} from 'lwc';
import SAMPLEMC from "@salesforce/messageChannel/MyMessageChannel__c"
import {publish, MessageContext} from 'lightning/messageService'

export default class SubscribePlatformEvent extends LightningElement
{

    @wire(MessageContext)
    messageContext;

   /* handleButtonClick(event) {
        let message = {messageText: 'This is a test'};
        console.log('message '+message);
        publish(this.messageContext, SAMPLEMC, message);
    }*/



	//Tracked variables ensure that they are refreshed on the page when their values are
	//updated in the code
    /*@track testData;
    @api name;

	//The api decorator makes this a public method that any component that houses this 
        //component can access/call
	@api childFunction(data)
	{
        
	    this.testData = data;
        console.log('is runing '+ this.testData);
	}*/

    //This method creates a custom event that dispatches itself.
    //The Aura component then handles this event
    communicateToAura()
    {
         console.log('Communicating to Aura ::: ');

         //We are grabbing the value from the lightning input field that has the dataToSend 
         //class
         let dataToSend = this.template.querySelector(".dataToSend").value;
        console.log('Communicating to Aura :22 ',dataToSend);
        //We are creating a custom event named senddata and passing a value in the detail 
        //portion of the custom event
        const sendDataEvent = new CustomEvent('sendData', {
            detail: {dataToSend}
        });
        console.log('Communicating to Aura :23 ',sendDataEvent.detail.dataToSend);
        //Actually dispatching the event that we created above.
        this.dispatchEvent(sendDataEvent);
    }
    @track testData;
    @api childFunction(data)
	{
        
	    this.testData = data;
        console.log('is runing '+ this.testData);
	}






/*import { LightningElement } from 'lwc';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled,
} from 'lightning/empApi';

export default class SubscribePlatformEvent extends LightningElement {
    channelName = '/event/Test__e';
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;

    subscription = {};

    // Tracks changes to channelName text field
    handleChannelName(event) {
        this.channelName = event.target.value;
    }

    // Initializes the component
    connectedCallback() {
        // Register error listener
        this.registerErrorListener();
    }

    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const messageCallback = function (response) {
            console.log('New message received: ', JSON.stringify(response));
            // Response contains the payload of the new message received
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            // Response contains the subscription information on subscribe call
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            this.subscription = response;
            this.toggleSubscribeButton(true);
        });
    }

    // Handles unsubscribe button click
    handleUnsubscribe() {
        this.toggleSubscribeButton(false);

        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, (response) => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }

    toggleSubscribeButton(enableSubscribe) {
        this.isSubscribeDisabled = enableSubscribe;
        this.isUnsubscribeDisabled = !enableSubscribe;
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }*/
}