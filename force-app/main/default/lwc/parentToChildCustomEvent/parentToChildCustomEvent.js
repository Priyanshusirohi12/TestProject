import { LightningElement } from 'lwc';

export default class ParentToChildCustomEvent extends LightningElement {
    userid = "101";
    username = "Priyanshu sirohi";

    handleSend(){
        //const userId = this.template.querySelector(".userId").value;
        //const userName = this.template.querySelector(".userName").value;
        const user = this.template.querySelectorAll(".user");

        console.log("12343"+ user);

       const details = {
           userid : user[0].value,
           username : user[1].value
       }    
       console.log("detail  : " + JSON.stringify(details));
       this.template.querySelector("c-child-custom-event").showDetails(details);
    }
    
}