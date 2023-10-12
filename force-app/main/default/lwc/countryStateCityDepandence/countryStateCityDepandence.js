import Country from '@salesforce/schema/Lead.Country';
import { LightningElement } from 'lwc';

export default class CountryStateCityDepandence extends LightningElement {
    dependancey = [ 
        {
            "india" : {
                "rajathan" : {
                    "ajmer"  : '305001',
                    "jaipur" : '305002',
                    "kota" : '305003'
                },
                "Gujrat" : {
                    "ahamdabad" : '405002',
                    "surat" : '405002',
                    "rajkot" : '405003'
                }
            },
            "pakisthan" : {
                "state1" : {
                    "pathancort" : '5005001',
                    "karachi" : '5005002'
                },
                "state2" : {
                    "lahor" : '6005001',
                    "hadrabad" : '6005001'
                }
            }
        }
    ]
    country="";
    state="";
    city="";
    pincode="";
    selectState;
    selectCity;

    constructor(){
        super();
        //console.log(this.dependancey);
       // console.log(this.dependancey[0]);
        //console.log(this.data[0][this.country]);
        //console.log(this.data[0][this.country][this.state]);
        //console.log(this.depandancy[0][this.country][this.state][this.city]);
        //console.log(this.depandancy[0][this.country][this.state][this.city][this.pincode]);
    }
    get selectCountry(){
        var selectCountry =[];
        
        for(var countryField in this.dependancey[0]){
            var obj = {};
            obj.label = countryField;
            obj.value = countryField;
            selectCountry.push(obj);
        }
        return selectCountry;
    }
     changeHandlerOnState(event){
        this.selectState = [];
        this.country = event.target.value;
        //this.state = event.target.value;
        for(var stateValue in this.dependancey[0][event.target.value]){
            
            var obj = {};
            obj.label =stateValue;
            obj.value = stateValue;
            this.selectState.push(obj);
        }
        
    }
    changeHandlerOnCity(event){
       // console.log(this.dependancey[0][event.target.value][event.target.value]);
       this.state = event.target.value;
       console.log('rohan  ');
        this.selectCity = [];
        for(var cityValue in this.dependancey[0][this.country][event.target.value]){
            var obj = {};
            obj.label = cityValue;
            obj.value = cityValue;
            this.selectCity.push(obj);
        }
        console.log('sharma');
    }
    changeHandlerOnPincode(event){
            this.pincode = this.dependancey[0][this.country][this.state][event.target.value];
            //console.log('dscf');
            //console.log('asdcs'+this.country+"state"+this.state+"city");
           // console.log(this.dependancey[0][this.country][this.state][event.target.value]);
           // this.pincode = this.dependancey[0][this.state][this.city][event.target.value];
        }
    
}