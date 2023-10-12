import { LightningElement } from 'lwc';

export default class CheckboxExample extends LightningElement {
    defaultChecked =['Travelling','Riding']
    selectCheckboxValue =this.defaultChecked;

    get fillCheckbox(){
        return [
            {label : 'Travelling', value : 'Travelling'},
            {label : 'Riding', value : 'Riding'},
            {label : 'Cricket', value : 'Cricket'},
            {label : 'Football', value : 'Football'}
        ];
    }
    changeHandler(event){
        this.selectCheckboxValue = event.detail.value;
        console.log("@@"+this.selectCheckboxValue);
    }
    
}