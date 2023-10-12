import { LightningElement ,wire } from 'lwc';
import {fireEvent,registerListener,unregisterAllListeners} from 'c/pubSub';
import { CurrentPageReference } from 'lightning/navigation';
import  getContactList  from '@salesforce/apex/SelectedAccountDeatail.getContactList';
import updateAccountRecord from '@salesforce/apex/SelectedAccountDeatail.updateAccountRecord';

export default class SelectedAccountDetail extends LightningElement {
    
     @wire(CurrentPageReference) pageRef;

    alldetails;
    accountId;
    Name;
    Email;
    Rating;
    Phone;
    checkEdit = false;
    contactList = [];
    hideEdit =false;
    hideUpdate = true;
    showtable = false;

   connectedCallback(){
        registerListener("detailButton",this.showRecords,this);
    }
    
    showRecords(data){
        this.showtable = true;
        this.accountId = data.Id;
        console.log(this.accountId);
        this.Name = data.name;
        this.Email = data.email;
        this.Rating = data.rating;
        this.Phone = data.phone;

        getContactList({id : data.Id})
        .then(result => {
            console.log(JSON.stringify(result));
            this.contactList = result;
        }).catch(error =>{
            console.log(error);
        })
    
    }
    handleEdit(){
        this.checkEdit = true;
        this.hideEdit = true;
        this.hideUpdate = false;
        
    }
    handleUpdate(){
        console.log('fdfd');
        const account = this.template.querySelectorAll(".account");
        const accountUpdate = {
            Id : this.accountId,
            Name : account[0].value,
            Email__c : account[3].value,
            Rating : account[2].value,
            Phone : account[1].value
        };
         updateAccountRecord({account : accountUpdate}).then(result=>{
           console.log('12333 ' +JSON.stringify(result));
           location.reload();
           this.loader = false;
       }).catch(error=>{
        console.log('!! '+JSON.stringify(error));
        this.loader = false;
       });
       this.checkEdit = false;
       this.hideEdit = false;
       this.hideUpdate = true;
    }
    disconnectedCallBack(){
        unregisterAllListeners(this);
    }
    

}