import { LightningElement, wire } from 'lwc';
import showAllContacts from '@salesforce/apex/SearchContactsController.showAllContacts';
export default class SearchContactsComponent extends LightningElement {
    contactList = [];
    allContactList = []; 
    inputSearch = '';
    pageSize = 5; 
    first;
    last;  
    contactSize; 
    
    connectedCallback(){
        this.searchContacts();
    }

    get options(){
        return[
            {label : "All", value : 0},

            {label : "5", value : 5},

            {label : "10", value : 10},

            {label : "15", value : 15},

            {label : "20", value : 20}
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
        this.allContactList = [];
        showAllContacts({inputSearch : this.inputSearch})
        .then(result => {
            console.log(result);
            result.forEach(element => {
                let contact = {
                    Name : element.Name, 
                    Email : element.Email, 
                    AccountName : element.Account === undefined  ? '' : element.Account.Name,
                    Phone : element.Phone, 
                    Type__c : element.Type__c
                };
                this.allContactList.push(contact); 
            });
            
            this.contactSize = this.allContactList.length; 
            this.fillSelectedListSize();

        }).catch(error =>{
                console.log('error '+error);
        })
    }

    fillSelectedListSize(){
        this.first = 0;
        if(this.pageSize != 0){
            this.last = this.pageSize;
            this.fillContacts(this.first, this.last);
        } else {
            this.contactList = this.allContactList;
            this.last = this.contactSize;
        }
    }

    fillContacts(start, end){
        this.contactList = [];
        this.allContactList.forEach((element, index) => {
            if(index >= start && index < end){
                this.contactList.push(element);
            }
        });
        console.log('gf '+start);
        console.log('Last '+end);
        /*for(; start < end; start++ ){
            this.contactList.push(this.allContactList[start]);     
        }*/
    }
    
    handleFirst(){
        if(this.contactList.length < this.contactSize){
            this.fillContacts(0, this.pageSize);
            this.first = 0;
            this.last = this.pageSize;
        }
    }

    handleNext(){
        if(this.last != this.contactSize){
            this.first = this.last;
            this.last = this.first + this.pageSize > this.contactSize 
            ? this.contactSize 
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
        this.first = (this.contactSize % this.pageSize) == 0  
        ? this.contactSize - this.pageSize 
        : this.contactSize - (this.contactSize % this.pageSize); 
        this.fillContacts(this.first, this.contactSize); 
        this.last = this.contactSize; 
    } 

    get disableFirstPrevious(){
        return this.first == 0 ? true : false;
    }

    get disableNextLast(){
        if(this.contactSize == this.contactList.length || this.last == this.contactSize){
            return true;
        }else{
            return false;
        }
    }
}