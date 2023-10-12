import { LightningElement } from 'lwc';

export default class NewCountry extends LightningElement {

    countryDetails = [
        {
            "india" :{
                "rajasthan" :{
                    "ajmer" : '305001',
                    "jaipur" : '305002',
                    "kota" : '305003'
                },
                "Gujrat" : {
                    "ahemdabad" : '405001',
                    "Surat" : '405002',
                    "rajkot" : '405003'
                }
            },
            "England":{
                "state1":{
                    "menchester" :'505001',
                    "landon" : '505002'
                },
                "state2" :{
                    "brimingam": '606001',
                    "liverpool" : '606002'
                }
            }
        }
    ]
    country ="";
    state ="";
    city ="";
    pincode="";
    selectState1;
    citySelect;
    
    
    get countryList(){
        var countryList = [];
        for(var countryFields in this.countryDetails[0]){
            var obj ={};
            obj.label = countryFields;
            obj.value =countryFields;
            countryList.push(obj);
        }
        return countryList;
    }
    selectCountry(event){
        this.selectState1 =[];

        this.country = [event.target.value];
        for(var stateValue in this.countryDetails[0][event.target.value]){
            var obj ={};
            obj.label = stateValue;
            obj.value = stateValue;
            this.selectState1.push(obj);
        }
        
    } 
    selectState(event){
        this.state = [event.target.value];
        console.log('@@@@ '+this.state);
        this.citySelect =[];
        for(var cityValue in this.countryDetails[0][this.country][event.target.value]){
            var obj ={};
            obj.label = cityValue;
            obj.value = cityValue;
            this.citySelect.push(obj);
        }

    }
    
    selectCity(event){
        this.pincode = this.countryDetails[0][this.country][this.state][event.target.value];
        console.log('11111 '+this.city);
        
    }
   
        
    
    
}