import { LightningElement } from 'lwc';
import getLanguage from '@salesforce/apex/TranslatorController.getLanguage';
import translater from '@salesforce/apex/TranslatorController.translater';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Translater extends LightningElement {
    getTranslatedList = [];
    setTranslatedList = [];
    translateLanguage = '';
    translatedLanguage = '';
    translateInput = '';
    translatedOutput = '';
    disableTranslateInput= true;


    connectedCallback(){
        this.setLanguagesList();
    }
    setLanguagesList(){
        getLanguage().then(result=>{
            console.log('result ',result);
            var getTranslatedList = [] 
            var setTranslatedList = []
            getTranslatedList.push({label :'none', value : ''})
            setTranslatedList.push({label :'none', value : ''})
            for(var i in result.languages){
                getTranslatedList.push({label :result.languages[i].name, value : result.languages[i].language})
                setTranslatedList.push({label :result.languages[i].name, value : result.languages[i].language})  
            }
            this.setTranslatedList = setTranslatedList;
            this.getTranslatedList = getTranslatedList;
        })
    }
    fillValues(event){
        console.log('yrgdrggdghdhfj');
        if(event.target.label == 'Translate In'){
            this.translatedLanguage = event.target.value 
            if(this.translateLanguage != '' && this.translatedLanguage != '' && this.translateInput){
                this.translateValue();
            }
        }else if(event.target.label == 'Translate To'){
            
            this.translateLanguage = event.target.value 
            if(this.translateLanguage != '' && this.translatedLanguage != '' && this.translateInput){
                this.translateValue();
            }
        }else if(event.target.label == 'Translate Input'){
            console.log(event.target.value);
            this.translateInput = event.target.value ;
        }
        this.disableTranslateInput = this.translateLanguage != '' && this.translatedLanguage != '' ? false : true;
    }
    translateValue(){ 
        console.log(this.translateLanguage, ' translateLanguage ',this.translatedLanguage,' translatedLanguage ', this.translateInput, ' translateInput');
        if(this.translateLanguage != '' && this.translatedLanguage != '' && this.translateInput != ''){
            var data= {q: this.translateInput, target: this.translatedLanguage, source: this.translateLanguage};

            translater({q : this.translateInput, target : this.translatedLanguage, source :this.translateLanguage}).then(result=>{
                console.log('result ',result.translatedText)
                this.translatedOutput = result.translatedText;
            })
        }else if(this.translateLanguage == '' || this.translatedLanguage == '' || this.translateInput == ''){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something is Not Selected',
                    message: 'Fill the values',
                    variant: 'error',
                }),
            );  
        }
    }


}