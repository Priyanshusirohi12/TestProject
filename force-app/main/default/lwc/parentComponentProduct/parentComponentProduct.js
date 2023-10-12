import { LightningElement, } from 'lwc';

export default class ParentComponentProduct extends LightningElement {
    check=false;
    quantity;
    product =[
        {
            id : 101,
            productImage : "/servlet/servlet.FileDownload?file=00P5g000000Ra5H",
            productName : "T-shirt",
            price : 500,
            productDecription : "Best t-shirts for sale",
            check :false
        },
        {
            id : 102,
            productImage : "/servlet/servlet.FileDownload?file=00P5g000000Ra6v",
            productName : "jeans",
            price : 1000,
            productDecription : "Best jeans for sale",
            check :false
        },
        {
            id : 103,
            productImage : "/servlet/servlet.FileDownload?file=00P5g000000Ra8Z",
            productName : "Jecket",
            price : 1500,
            productDecription : "Best jeckets for sale",
            check : false 
        },
        {
            id : 104,
            productImage : "/servlet/servlet.FileDownload?file=00P5g000000Ra8e",
            productName : "shorts",
            price : 600,
            productDecription : "Best shorts for sale",
            check :false
        }
    ]
    
    handleOncheckbox(event){
        this.quantity =0;
        for(var i =0; i < this.product.length; i++){
            if(event.target.value == this.product[i].id){
                this.product[i].check = event.target.checked;
                console.log(this.product[i].check+' fdf '+this.product[i].id);  
            } 
            else if(event.target.value != this.product[i].id){
                this.product[i].check = false;
                console.log(this.product[i].check+' fdf '+this.product[i].id)
            }
        }
        console.log("hello "+event.target.value);
        let newArray = this.product.filter(item=>{
            return item.id == event.target.value;
        });
       const details =  {
            id : newArray[0].id,
            productName : newArray[0].productName,
            productImage : newArray[0].productImage,
            price : newArray[0].price,
            productDecription : newArray[0].productDecription,
            check : event.target.checked
        }
            console.log("details "+JSON.stringify(details));
        this.template.querySelector("c-child-component-product").showDetails(details);
        //this.template.querySelector("c-child-component-product").quantity;
    }
   
    handelSimpleEvent(event){
                this.quantity =event.detail.quantity;
                console.log('@@@@ '+this.quantity);
    }
}