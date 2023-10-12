import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, api } from 'lwc';

export default class ChildComponentProduct extends LightningElement {
     quantity;
    @api id;
    @api productName;
    @api productImage;
    @api price;
    @api productDecription;

    @api showDetails(data){
        this.quantity=0;
        this.id =data.id;
        this.productName=data.productName;
        this.productImage = data.productImage;
        this.productDecription =data.productDecription;
        this.price =data.price;
    }
    countOfProduct(){
        console.log('happy');
        //console.log("lallit "+count);
        if(this.quantity<=2){
        this.quantity++;
        }
        console.log('232 '+this.quantity);
        const countObj = {
            quantity : this.quantity
        }
        
        const customEvent = CustomEvent('simpleevent',{
            detail : countObj
        });
        console.log('sadet '+JSON.stringify(customEvent));
        this.dispatchEvent(customEvent);
    }
}