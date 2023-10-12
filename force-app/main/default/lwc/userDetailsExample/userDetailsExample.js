import { LightningElement,api,wire } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
export default class UserDetailsExample extends LightningElement {
    userId =USER_ID;
    userName;
    userObj={};
    @wire(getRecord, {
        recordId : USER_ID,
        fields : ['User.FirstName', 'User.LastName']
    }) usreDetail({error , data}){
        if(data){
            this.userObj ={
                LastName : data.fields.LastName.value
                
            };
            this.usereName =data.fields.FirstName.value;
            console.log('@@ '+JSON.stringify(data));
            console.log('##1234 '+this.userObj);
            console.log('## '+this.userName);
        }
        else{
            console.log('11 '+ error);
        }
    }
}