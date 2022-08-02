import { LightningElement } from 'lwc';
//import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
//import domToImg from '@salesforce/resourceUrl/domToImage';

export default class DomToImage extends LightningElement {
    // @track dtImg
    // connectedCallback(){  
    //         //this.ganttInitialized = true;
    //     Promise.all([
    //         loadScript(this, domToImg + '/domToImage.js')
    //     ]).then(result =>{
    //         this.dtImg = result;
    //         console.log('reult', result);
    //     }).catch(error => {
    //         console.log('gant error',error);
    //         this.displayToastMessage('No Gantt Load', 'Error loading Gantt', 'error')
    //     });    
    // }

    
    // handleOnClick(){
    //     let node = this.template.querySelector('.my-node');
    //     console.log('node ', node);
    //     let options = {
    //         quality: 0.95 
    //     };

    //     dtImg.toPng(node).then(function (dataUrl) {
    //         let img = new Image();
    //         img.src = dataUrl;
    //         document.body.appendChild(img);
    //     }).catch(function (error) {
    //         console.error('oops, something went wrong!', error);
    //     });
    // }
    
}