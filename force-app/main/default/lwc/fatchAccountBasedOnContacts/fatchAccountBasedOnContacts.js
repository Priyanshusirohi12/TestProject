import { LightningElement, track } from 'lwc';
import getContactBaseOnAccount from '@salesforce/apex/fatchContactBasedOnAccount.getContactBaseOnAccount'
export default class FatchAccountBasedOnContacts extends LightningElement {
    accountId = "0015g000007YWsNAAW";
    Rating = "Cold";
    @track contactList;
    @track isModalOpen = false;
    openModal() {

        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.contactList = []
        console.log(this.accountId);
        console.log(this.Rating);
        getContactBaseOnAccount({accountId : this.accountId, rating : this.Rating}).then(result=>{
            console.log('result ', JSON.stringify(result));
            result.forEach(element => {
                let contact ={
                    Name : element.Name, 
                    Email : element.Email, 
                    Phone : element.Phone, 
                    Title : element.Type__c
                };
                this.contactList.push(contact); 
            });
            console.log('contactList ',JSON.parse(JSON.stringify(this.contactList)));
        }).catch(error=>{
            console.log(error);
        })

    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
    
   
        
}