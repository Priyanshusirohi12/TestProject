import { LightningElement, track, api } from 'lwc';
import {loadScript } from 'lightning/platformResourceLoader';
import JSPdf2 from "@salesforce/resourceUrl/JSPdf2";
import domToImage from '@salesforce/resourceUrl/domToImage';
import searchContact from '@salesforce/apex/SearchableController.searchContact';

export default class DTI extends LightningElement {

  @api listOfRecords
  @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
  @api required = false;
  @api Label;
  @api selectRecordName ='';
  @track iconFlag =  true;
  @track clearIconFlag = false;
  @api searchRecords = [];
  @track messageFlag = false;
  @api LoadingText = false;
  @api objectName;
  @api selectRecordId ='';
  @api projectId;
  @api checkUser = ''; 
    // renderedCallback() {
    //     loadScript(this, JSPdf2).then(() => {});
    //   }
    connectedCallback(){
       console.log('selectRecordId ',this.selectRecordId);
       console.log('selectRecordName ',this.selectRecordName);
       console.log('objectName ', this.objectName);
       console.log('checkUser', this.checkUser);
      if(this.selectRecordName !='' && this.selectRecordId != ''){
        this.iconFlag = false;
        this.clearIconFlag = true;
      }
    }  
    searchField(event){
      var currentText = event.target.value;
      this.LoadingText = true;
      // if(currentText == ''){
      //     this.publishMessage(null, null,false);
      // }
      // ObjectName: this.objectName, fieldName: this.fieldName, value: currentText
      this.getProjectList(currentText);
  }
  getProjectList(currentText){
    console.log('objectName ',this.objectName);
    console.log('projectId ', this.projectId);
    console.log('checkUser ', this.checkUser);
    console.log('currentText ',currentText);
    searchContact({value: currentText, objectName : this.objectName, projectId : this.projectId, owner : this.checkUser})
    .then(result => {  
        this.searchRecords= result;
        this.LoadingText = false; 
        this.txtclassname =  result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        if(currentText.length > 0 && result.length == 0) {
            this.messageFlag = true;
        }
        else{
            this.messageFlag = false;
        }
        if(this.selectRecordId != null && this.selectRecordId.length > 0){
            this.iconFlag = false;
            this.clearIconFlag = true;
        }
        else{
            this.iconFlag = true;
            this.clearIconFlag = false;
        }
    })
    .catch(error => {
        console.log('-------error-------------',error);
    });
  }
  setSelectedRecord(event){
    
    const selectedEvent = new CustomEvent("progressvaluechange", {
      detail: { 
        Id : event.currentTarget.dataset.id,
        Name : event.currentTarget.dataset.name,
        objectName : this.objectName,
        user : this.checkUser
      }
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);

    
     var currentRecId = event.currentTarget.dataset.id;
     this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
     this.selectRecordName = event.currentTarget.dataset.name;
     this.selectRecordId = currentRecId;
     console.log('selectRecordId ',this.selectRecordId);
     this.iconFlag = false;
     this.clearIconFlag = true;
     this.inputReadOnly = true;
 }
  resetData(event){
    this.selectRecordName = "";
    this.selectRecordId = "";

    const selectedEvent = new CustomEvent("progressvaluechange", {
      detail: { 
        Id : this.selectRecordId,
        Name : this.selectRecordName,
        objectName : this.objectName,
        user : this.checkUser 

      }
    });
    this.dispatchEvent(selectedEvent);

    this.inputReadOnly = false;
    this.iconFlag = true;
    this.clearIconFlag = false;
    
}  




}
