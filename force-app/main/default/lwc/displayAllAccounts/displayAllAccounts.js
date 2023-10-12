import { LightningElement, wire } from 'lwc';
import {fireEvent,registerListener,unregisterAllListeners} from 'c/pubSub';

import getAccountSearchingRecord from '@salesforce/apex/DisplayAllAccountsController.getAccountSearchingRecord';
import deleteRecord from '@salesforce/apex/DisplayAllAccountsController.deleteRecord';
import fatchRecord from '@salesforce/apex/DisplayAllAccountsController.fatchRecord';
import { CurrentPageReference } from 'lightning/navigation';

export default class DisplayAllAccounts extends LightningElement {

    @wire(CurrentPageReference) pageRef;

    Id;
    searchValue = '' ;    
    accounts = [];
    allAccountList = [];
    details = {};
    connectedCallback(){
        this.searchAccounts();
    }
    
    search(event) {
        this.searchValue = event.target.value;
    }

    searchAccounts(){
        this.allAccountList = [];
        getAccountSearchingRecord({searchkey: this.searchValue})
        .then(result => {
                this.allAccountList = result;

        }).catch(error =>{
                console.log('error '+error);
        })
    }

    handleDetail(event) {
       this.Id = event.target.value;
       fatchRecord({id : this.Id}).then(result=>{
            this.details = result;
             var data = {
                Id :    result.Id,
                name : result.Name,
                rating : result.Rating,
                email : result.Email__c,
                phone : result.Phone
            }
            fireEvent(this.pageRef,"detailButton",data)

        }).catch(error=>{
            console.log('!! '+JSON.stringify(error));
        });   
    }

    handleDelete(event){
        this.deleteId = event.target.name;
        deleteRecord({delId : this.deleteId})
        .then(result =>{
            this.allAccountList = result;
            location.reload(); 
            
        }).catch(error => {
            console.log("Error : "+JSON.stringify(error));
        });
    }
    disconnectedCallBack(){
        unregisterAllListeners(this);
    }

}