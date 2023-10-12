import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import {fireEvent } from 'c/pubSub';


export default class PubSubProductSale extends LightningElement {
    @track price;
    @track product;
    @track quantity;
    @wire (CurrentPageReference) pageRef;
    @track id=0;
    get productsList(){
        return [
                {label : "Mouse", value : "Mouse"},
                {label : "LCD", value : "LCD"},
                {label : "CPU", value : "CPU"},
                {label : "Printer", value : "Printer"}
        ]
    }
    get quantityList(){
        return [
            {label : '1' , value : '1'},
            {label : '2' , value : '2'},
            {label : '3' , value : '3'},
            {label : '4' , value : '4'},
            {label : '5' , value : '5'},
            {label : '6' , value : '6'},
        ]
    }
    handler(){
        this.id++;
        const price = this.template.querySelectorAll(".priceValue");
        const product = this.template.querySelectorAll(".productValue");
        const quantity = this.template.querySelectorAll(".quantityValue");
            
             this.price= price[0].value;
             this.quantity= quantity[0].value;
             this.product = product[0].value;
            // console.log('price  '+this.price);
            //console.log('product  '+this.product);
            //console.log('quantity  '+this.quantity);
            var details ={
                id :    this.id,
                price : this.price,
                product : this.product,
                quantity : this.quantity
            }
            fireEvent(this.pageRef,"fatchDetails",details);
    }
}