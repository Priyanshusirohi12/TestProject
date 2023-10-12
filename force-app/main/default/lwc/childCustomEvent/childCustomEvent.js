import { LightningElement, api } from 'lwc';

export default class ChildCustomEvent extends LightningElement {
    @api userid;
    @api username;

    @api showDetails(data){
        console.log(JSON.stringify(data));
        this.userid = data.userid;
        this.username = data.username;
    }
}