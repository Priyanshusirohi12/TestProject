import { LightningElement } from 'lwc';

export default class CalculaterAssignment extends LightningElement {
    firstValue;
    secondValue;
    thirdValue=0;
    enableButton=true;
    oprator;
    //input value to perform oprations
    changeHandler(event){
        this.enableButton=false;
        if(event.target.label == "Enter First Value"){
            this.firstValue = parseFloat(event.target.value);
            if(isNaN(this.firstValue)){
               this.firstValue=0; 

            }
        }
        else if(event.target.label == "Enter Second Value"){
            this.secondValue=parseFloat(event.target.value);
            if(isNaN(this.secondValue)){
                this.secondValue=0;
            }
        }
    }

    //Oprator to perform oprations
    applyOpprator(event){
        this.oprator = event.target.title;
        if(this.oprator == "+"){
            this.thirdValue = parseFloat(this.firstValue) + parseFloat(this.secondValue);
        }
        else if(this.oprator == "-"){
            this.thirdValue = parseFloat(this.firstValue) - parseFloat(this.secondValue);
        }
        else if(this.oprator == "*"){
            this.thirdValue = parseFloat(this.firstValue) * parseFloat(this.secondValue);
        }
        else if(this.oprator == "/"){
            this.thirdValue = parseFloat(this.firstValue) / parseFloat(this.secondValue);
           
        }
        else if(this.oprator == "%"){
            this.thirdValue = parseFloat(this.firstValue) %  parseFloat(this.secondValue); 
        }
        if(isNaN(this.thirdValue)){
            this.thirdValue = 0;
        }
        if(!isFinite(this.thirdValue)){
            this.thirdValue="Invalid Value";
        }
       
    }
   
  /*  getAdd(event){
        this.thirdValue = parseInt(this.firstValue) + parseInt(this.secondValue);
        //event.target.value=this.thirdValue; 
    }
    getSubtract(event){
        this.thirdValue = this.firstValue - this.secondValue;
    }
    getMultiply(event){
        this.thirdValue = this.firstValue * this.secondValue;
    }
    getDivide(event){
        this.thirdValue = this.firstValue / this.secondValue;
    }
    getMod(event){
        this.thirdValue = this.firstValue % this.secondValue;
    }*/
    
}