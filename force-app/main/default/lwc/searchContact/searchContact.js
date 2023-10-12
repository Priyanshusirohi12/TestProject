import { LightningElement, wire } from 'lwc';
import showAllContacts from '@salesforce/apex/SearchContactsController.showAllContacts';
export default class SearchContact extends LightningElement {
    contactList = [];
    temporaryContactList = []; 
    inputSearch = '';
    pageSize = 5; 
    first;
    last;     
    connectedCallback(){
        this.searchContacts();
    }
    fillSelectedListSize(){
        this.first = 0;
        if(this.pageSize != 0){
            this.last = this.pageSize;
            this.fillContacts(this.first, this.last);
        }
        else{
            this.contactList = this.temporaryContactList;
            this.last = this.temporaryContactList.length;
        }
    }
    fillContacts(start, end){
        this.contactList = [];
         this.temporaryContactList.forEach((element, index) => {
            if(index >= start && index < end){
                this.contactList.push(element);
            }
        });
    }
    get options(){
        return[
            {label : "All" 	, 	value : 0},
            {label : "5" 	,   value : 5},
            {label : "10" 	,  	value : 10},
            {label : "15" 	,  	value : 15},
            {label : "20" 	,  	value : 20}
        ]
    }
    handlePageSize(event){
        this.pageSize = parseInt(event.target.value);
        this.fillSelectedListSize();
    }
    handleStringValue(){
        const inputSearch = this.template.querySelectorAll(".input");
        this.inputSearch = inputSearch[0].value;
    } 
    searchContacts(){
        this.temporaryContactList = [];
        showAllContacts({inputSearch : this.inputSearch})
        .then(result => {
            console.log('hello ',result);
            result.forEach(element => {
                let contact ={
                    Name : element.Name, 
                    Email : element.Email, 
                    AccountName : element.Account === undefined  ? '' : element.Account.Name,
                    Phone : element.Phone, 
                    Type__c : element.Type__c
                };
                this.temporaryContactList.push(contact); 
            });
            this.fillSelectedListSize();

        }).catch(error =>{
                console.log('error '+error);
        })
    }    
    handleFirst(){
        if(this.contactList.length < this.temporaryContactList.length){
            this.fillContacts(0, this.pageSize);
            this.first = 0;
            this.last = this.pageSize;
        }
    }
    handleNext(){
        if(this.last != this.temporaryContactList.length){
            this.first = this.last;
            this.last = this.first + this.pageSize > this.temporaryContactList.length 
            ? this.temporaryContactList.length 
            : this.first + this.pageSize;
            this.fillContacts(this.first, this.last);
        }
    }
    handlePrevious(){
        this.first = this.first - this.pageSize < 0 ? 0 : this.first - this.pageSize;
        this.last = this.pageSize + this.first;
        this.fillContacts(this.first, this.last);        	 
    }
    handleLast(){
        this.first = (this.temporaryContactList.length % this.pageSize) == 0  
        ? this.temporaryContactList.length - this.pageSize 
        : this.temporaryContactList.length - (this.temporaryContactList.length % this.pageSize); 
        this.fillContacts(this.first, this.temporaryContactList.length); 
        this.last = this.temporaryContactList.length; 
    } 
    get disableFirstPrevious(){
        return this.first == 0 ? true : false;
    }
    get disableNextLast(){
        return this.temporaryContactList.length == this.contactList.length 
        || this.last == this.temporaryContactList.length
        ? true : false;
    }
}