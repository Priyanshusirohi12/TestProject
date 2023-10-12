import { LightningElement, wire } from 'lwc';
import getAccountList from '@salesforce/apex/ContactController.getAccountList';
import getContactList from '@salesforce/apex/ContactController.getContactList';
export default class ContactAndAccountListWithApexClass extends LightningElement {
    accounts;
    contacts;
    handleOnAccount(){
        getAccountList().then(result => {
            console.log('@@@@ '+JSON.stringify(result));
            this.accounts = result;
        }).catch(error => {
            console.log('123 '+JSON.stringify(error));
        });
    }
  @wire(getContactList) contactList({data,error}){
       if(data){
        this.contacts = data;
           console.log("1245 "+JSON.stringify(data));
       }
       else{
           console.log("!!! "+JSON.stringify(error));
       }
   }
}