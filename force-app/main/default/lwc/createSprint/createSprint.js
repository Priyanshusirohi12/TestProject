import { LightningElement,wire, track,api} from 'lwc';
import getStatusPickListValues from '@salesforce/apex/InsertGanttProductAndSprint.getStatusPickListValues';
import getGanttProjectTypePickListValues from '@salesforce/apex/InsertGanttProductAndSprint.getGanttProjectTypePickListValues';
import getTaskStatusPickList from '@salesforce/apex/InsertGanttProductAndSprint.getTaskStatusPickList';
import SAMPLEMC from "@salesforce/messageChannel/MyMessageChannel__c"
import {MessageContext, publish} from 'lightning/messageService';
import insertProject from '@salesforce/apex/InsertGanttProductAndSprint.insertProject';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord, updateRecord, deleteRecord } from 'lightning/uiRecordApi';
import compareSprintDates from '@salesforce/apex/InsertGanttProductAndSprint.compareSprintDates';
import getGanttProject from '@salesforce/apex/InsertGanttProductAndSprint.getGanttProject';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
    export default class CreateSprint extends LightningElement {

        projectSaveButtonDisable =false;
        sprintSaveButtonDisable = false;
        @track ganttProjectList = []
        SprintStatusPickListValues =[]
        projectList = []
        ganttProjectValue;
        enableFilter = true;
        isSprintInsertModelOpen = false;
        isGanttProjectInsertModelOpen = false;
        statusPickList = [];
        isTaskModelOpen = false;
        taskStatusPickList = []
        checkedValues =[]
        contactList=[]
        checkboxValuesInString;
        projectDateList = [];
        
        
        startDate;
        endDate;
        status;
        cost;
        isDeleteProjectModalOpen = false;
        hideProjectUpdateButton = false;
        
        @api selectRecordId = '';
        @api selectRecordName;
        @api Label;
        @api searchRecords = [];
        @api required = false;
        @api iconName = 'action:new_account'
        @api LoadingText = false;
        @track projectIdForSprintModel;
        @track projectNameForSprintModel;
        @track projectName = '';
        @track projectId = '';
        @track client;
        @track clientName;    
        @track objectName;
        @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        @track messageFlag = false;
        @track iconFlag =  true;
        @track clearIconFlag = false;
        @track inputReadOnly = false;
        handdleSpinner = false

        @wire(MessageContext)
        context
   
        publishMessage(projectId, checkedValues, toDownloadImg){
            const message = {
                lmsData : {
                    value : projectId,
                    statusFilterValues : checkedValues,
                    toDownloadImg : toDownloadImg
                }
            }
            publish(this.context, SAMPLEMC, message);
        }
        
        hanldeProgressValueChange(event){
            if(event.detail.objectName == 'Contact'){
                this.client = event.detail.Id,
                this.clientName = event.detail.Name
                
            }else if(event.detail.objectName == 'Gantt_Project__c'){
                this.projectIdForSprintModel = event.detail.Id;
                this.projectNameForSprintModel = event.detail.Name;
                
            }
        }

        openSprintInsertModel(){
            this.objectName = 'Gantt_Project__c';     
            //console.log('project Id ',this.projectId);
            this.projectIdForSprintModel = this.projectId;
            this.projectNameForSprintModel = this.projectName;  
                this.isSprintInsertModelOpen = true;
                this.sprintSaveButtonDisable = false;
            
            getStatusPickListValues().then(result=>{
                var sprintStatusPickListValues= [];
                sprintStatusPickListValues.push({label : '--None--', value : ''})
                var projectList =[]
                for(var i in result.picklistValues){
                    sprintStatusPickListValues.push({label : result.picklistValues[i], value : result.picklistValues[i]})
                }
                this.SprintStatusPickListValues = sprintStatusPickListValues;
                this.projectDateList = [];    
                for(var i in result.projectList){
                    var Name = result.projectList[i].split('& ')[0];
                    var Id = result.projectList[i].split('& ')[1];    
                    projectList.push({label : Name, value : Id})
                    this.projectDateList.push({label : result.projectDateList[i], value : Id});
                }
                this.projectList = projectList;
            })  
        }  
        closeModal(){
            this.isSprintInsertModelOpen = false;
            this.isGanttProjectInsertModelOpen = false;
            this.isTaskModelOpen = false;
            this.isTaskModelOpen = false;
            this.projectId = this.projectIdForSprintModel
            this.isDeleteProjectModalOpen =  false
            this.projectName = this.projectNameForSprintModel
        } 
        getprojectLists(){
            getGanttProjectTypePickListValues().then(result=>{
                var statusPickList = []
                var contactList = []
                for(var i in result.contactList){
                    var Name = result.contactList[i].split('& ')[0];
                    var Id = result.contactList[i].split('& ')[1];
                    contactList.push({label : Name, value : Id})
                }
                this.contactList = contactList;
                statusPickList.push({label : '--None--', value : ''});
                for(var i in result.statusPickList){
                    statusPickList.push({label : result.statusPickList[i], value : result.statusPickList[i]})
                }
                this.statusPickList = statusPickList;
            })     
        }
        openGanttProjectInsertModel(){
            this.objectName ='Contact'
            this.projectId = null
            this.projectName = ''
            this.cost = ''
            this.startDate='';
            this.endDate = '';
            this.status = '';
            this.client = '';
            this.clientName = '';
            this.isGanttProjectInsertModelOpen = true;
            this.projectSaveButtonDisable = false;
            this.getprojectLists();
        }


        openGanttProjectUpdateModel(event){
            this.objectName ='Contact'
            this.getprojectLists();
            //this.ganttProjectList
            var projectObject = this.ganttProjectList.filter(result =>{return result.Id.indexOf(event.target.value) !== -1})
            projectObject = projectObject[0];
            this.projectId = projectObject.Id
            this.projectName = projectObject.Name
            this.cost = projectObject.Cost__c
            this.startDate= projectObject.Start_Date__c
            this.endDate = projectObject.End_Date__c;
            this.status = projectObject.Status__c
            this.client = projectObject.Client__c;
            this.clientName = projectObject.Client__r.Name;

            this.isGanttProjectInsertModelOpen = true;
            this.projectSaveButtonDisable = false;   
        }
        setProjectRecords(event){    
            if(event.target.label=='Name'){
                this.projectName = event.target.value;
            }
            // if(event.target.label=='Client'){
            //     this.client = event.target.value;
            // }
            if(event.target.label=='Status'){
                this.status = event.target.value; 
            }            
            if(event.target.label=='Start Date'){
                this.startDate = event.target.value;
            }
            if(event.target.label=='End Date'){
                this.endDate = event.target.value;
            }         
            if(event.target.label == 'Cost'){
                this.cost = event.target.value;
            }
        }
        // fillGanttProjectId(event){
        //     console.log('projectIdForSprintModel ',this.projectIdForSprintModel);
        //     console.log('event ',event.target.value);
        //     this.projectIdForSprintModel = event.target.value;
        // }
        insertSprint(){
            const sprintRecord = this.template.querySelectorAll(".sprintRecord");
            var startDate = new Date(sprintRecord[1].value);
            var endDate = new Date(sprintRecord[2].value);
            const duration = Math.ceil(Math.abs(endDate - startDate) / (1000 * 60 * 60 * 24));
            var projectStartDate;
            var projectEndDate;
            //change code use filter insted of loop
            for(var i in this.projectDateList){
                if(this.projectDateList[i].value == this.projectIdForSprintModel){
                    projectStartDate = this.projectDateList[i].label.split(' /')[0];
                    projectEndDate = this.projectDateList[i].label.split(' /')[1];
                    break;
                }
            }
            const sprintRecordObject = { apiName: "Sprint__c", fields:{
                Name : sprintRecord[0].value,
                Gantt_Project__c : this.projectIdForSprintModel,
                Start_Date__c : sprintRecord[1].value,
                End_Date__c : sprintRecord[2].value,
                Duration__c : duration,       
                Status__c : sprintRecord[3].value,
            }};
            var sprintObject = sprintRecordObject.fields;
            console.log('fields ', sprintObject);
            if(sprintObject.Name !=null && sprintObject.Status__c != null 
                && sprintObject.Status__c != undefined && sprintObject.Start_Date__c != null 
                && sprintObject.End_Date__c != null && sprintObject.Duration__c != null 
                && sprintObject.Duration__c != NaN && sprintObject.Gantt_Project__c != null 
                && sprintObject.Name != '' && /\S/.test(sprintObject.Name) && sprintObject.Status__c != '' 
                && sprintObject.Start_Date__c != '' && sprintObject.End_Date__c != '' 
                && sprintObject.Duration__c != '' && sprintObject.Gantt_Project__c != ''){ 

                if(!(sprintRecordObject.fields.Start_Date__c <= sprintRecordObject.fields.End_Date__c)){
                    this.displayToastMessage('error', 'Start date should be below then end date')
                }else{
                    var sprintStartDateValue = new Date(sprintRecord[1].value).setUTCHours(-5);
                    sprintStartDateValue = new Date(sprintStartDateValue).setUTCMinutes(-30);
                    sprintStartDateValue = new Date(sprintStartDateValue)
                    var sprintEndDateValue = new Date(sprintRecord[2].value).setUTCHours(-5);
                    sprintEndDateValue = new Date(sprintEndDateValue).setUTCMinutes(-30);
                    sprintEndDateValue = new Date(sprintEndDateValue);
                    if(Date.parse(projectStartDate) <= sprintStartDateValue 
                    && Date.parse(projectEndDate) >= sprintEndDateValue){
                        
                        this.handdleSpinner = true;
                        createRecord(sprintRecordObject).then(res => {
                            this.sprintSaveButtonDisable = true;
                            this.isSprintInsertModelOpen = false;
                            this.handdleSpinner = false;
                        this.displayToastMessage('success', 'Record is Inserted')
                            if(this.selectRecordId  === sprintRecordObject.fields.Gantt_Project__c){
                                this.publishMessage(sprintRecordObject.fields.Gantt_Project__c, null,false);
                            }   
                        });   
                    }
                    if(new Date(projectStartDate) > sprintStartDateValue){
                        var projectSDate = new Date(projectStartDate).toString().split(' 00:')[0];
                        this.displayToastMessage('error', 'Start Date should be later or equal to project start date ('+projectSDate+')')
                    }else if(new Date(projectEndDate) < sprintEndDateValue){
                        var projectEDate = new Date(projectEndDate).toString().split(' 00:')[0];
                        this.displayToastMessage('error', 'End Date should be below or equal to project end date ('+projectEDate+')')
                    }
                }        
            }else{
                this.displayToastMessage('error', 'Please Fill the required fields')
            }
        }
        async insertGanttProject(){
            // if(this.projectId != null){
            //     compareSprintDates({projectId : this.projectId}).then(result=>{
            //     })
            // }
            var startDate = new Date(this.startDate);
            var endDate = new Date(this.endDate);
            
            const duration = this.startDate != '' || this.endDate != '' ? Math.ceil(Math.abs(endDate - startDate) / (1000 * 60 * 60 * 24)) : 0;      
            const fields = {
                Id : this.projectId,
                Name : this.projectName,
                Client__c : this.client,
                Start_Date__c : this.startDate,
                End_Date__c : this.endDate,
                Status__c : this.status,
                Cost__c : this.cost,
                Duration__c : duration
            };
            console.log('fields ',fields);
            if(fields.Name != '' && /\S/.test(fields.Name) && fields.Start_Date__c != '' 
                && fields.End_Date__c != '' && fields.Status__c != '' && fields.Client__c != '' 
                && fields.Duration__c != 0 && fields.Name != null && fields.Start_Date__c != null 
                && fields.End_Date__c != null && fields.Status__c != null && fields.Client__c != null){
                var sprintDates = null
                if(!(fields.Start_Date__c <= fields.End_Date__c)){
                    this.displayToastMessage('error', 'Start date should be below then end date')
                }else{
                    if(this.projectId != null){       
                        compareSprintDates({projectId : this.projectId}).then(result=>{
                            sprintDates = result;
                            if(result != null){
                                if(new Date(sprintDates.sprintMinStartDate) < new Date(fields.Start_Date__c)){
                                    var sprintSDate = new Date(sprintDates.sprintMinStartDate).toString().split(' 05:')[0];
                                    this.displayToastMessage('Error', 'Sprints are exist with lower start date on this gantt project (Lowest sprint start date is '+sprintSDate+')');
                                }else if(new Date(sprintDates.sprintMaxEndDate) > new Date(fields.End_Date__c)){
                                    var sprintEDate = new Date(sprintDates.sprintMinStartDate).toString().split(' 05:')[0];
                                    this.displayToastMessage('Error', 'Sprints are exist with higher end date on this gantt project (Highest sprint end date is '+sprintEDate+')');
                                }else if(new Date(sprintDates.sprintMinStartDate) >= new Date(fields.Start_Date__c) || new Date(sprintDates.sprintMaxEndDate) <= new Date(fields.End_Date__c)){
                                    this.updateProject(fields, 'Record is updated sucessfully');
                                } 
                            }else if(result == null){
                                this.updateProject(fields, 'Record is updated sucessfully')
                            }  
                        })
                    }   
                    else if(this.projectId == null || sprintDates == null){
                        this.updateProject(fields, 'Record is inserted sucessfully');
                    } 
                }
            }else{
                this.displayToastMessage('error', 'Please Fill the required fields')
            }       
        }
        openModalForDeleteSprint(event) {
            this.isDeleteProjectModalOpen = true;
            this.projectId = event.target.value;
        }
        toFillTheGanttProjectList(){
            getGanttProject({value: ''}).then(result => {  
                    this.ganttProjectList = result;
            })
        }
        updateProject(fields, message){
            this.handdleSpinner = true;
                insertProject({project :fields}).then(result => {
                    this.projectSaveButtonDisable = true;
                    this.hideProjectUpdateButton = true;
                    //this.getProjectList('');
                    this.toFillTheGanttProjectList();
                    this.taskStatusPickList =[]
                    this.publishMessage(result.Id, null, false);
                    this.ganttProjectValue = result.Id;
                    console.log('result. id ',result.Id);
                    this.selectRecordId = result.Id;
                    this.projectId = result.Id;                         
                    this.selectRecordName = result.Name;
                    this.clearIconFlag = true;
                    this.iconFlag = false;

                    // if(this.selectRecordName != ""){
                    //     this.taskStatusPickList = [];
                    // }
                    this.enableFilter = false;
                    this.handdleSpinner = false;
                    this.displayToastMessage('success', message)
                    this.isGanttProjectInsertModelOpen = false;
                });
        }
        handleDeleteRecord(){
            this.handdleSpinner =true
            deleteRecord(this.projectId)
                .then(() => {
                    this.handdleSpinner = false
                    this.displayToastMessage('Success', 'Record Deleted'); 
                    //this.ganttProjectList = [];
                    this.projectId = null;
                    this.clearIconFlag = false;
                    this.iconFlag = true;
                    this.hideProjectUpdateButton = false;
                    //this.getProjectList(''); 
                    this.toFillTheGanttProjectList();
                    this.taskStatusPickList =[]
                    this.selectRecordId = ''     
                    this.selectRecordName = ''
                    this.enableFilter = true;
                    this.publishMessage(null, null, false);
                    //this.isGanttProjectInsertModelOpen = false;
                    this.isDeleteProjectModalOpen = false;
                })
        }

        taskFilter(){
            //this.checkedValues = []
            getTaskStatusPickList().then(result=>{
                //this.taskStatusPickList = result;
                if(this.taskStatusPickList.length == 0){
                    var statusValues = []
                    for(var i in result){
                        statusValues.push({value : result[i], label : false})
                    }
                    this.taskStatusPickList = statusValues;
                }
                this.isTaskModelOpen = true ;
            }).catch(error=>{
            })
        }
        handleCheckbox(event){
            if(event.target.checked){
                this.taskStatusPickList[event.currentTarget.dataset.index].label = true;
                if(event.target.value == 'Not Started'){
                    //data-index={index}
                    this.checkedValues.push(event.target.value); 
                }
                else if(event.target.value == 'In Progress'){
                    this.checkedValues.push(event.target.value); 
                }
                else if(event.target.value == 'Completed'){
                    this.checkedValues.push(event.target.value); 
                }
                else if(event.target.value == 'Waiting on someone else'){
                    this.checkedValues.push(event.target.value); 
                }
                else if(event.target.value == 'Deferred'){

                    this.checkedValues.push(event.target.value); 
                }
            }if(event.target.checked == false){
                this.taskStatusPickList[event.currentTarget.dataset.index].label = false;
                var index = 0;
                for(var i in this.checkedValues){
                    if(this.checkedValues[i] == event.target.value){
                        index = i;
                    }
                }
                delete this.checkedValues[index];
                var filtered = this.checkedValues.filter(function (el) {
                    return el != null;
                });
                this.checkedValues = filtered;
            }     
        }
        sendSelectedCheckboxList(){
            this.publishMessage(this.selectRecordId, this.checkedValues, false);
            this.isTaskModelOpen = false;
        }
        getProjectList(currentText){
            getGanttProject({value: currentText})
            .then(result => {
                if(this.ganttProjectList.length == 0){
                    
                    this.ganttProjectList = result;
                }
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
                console.log('-------error-------------'+error);
            });
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
       setSelectedRecord(event){
           this.hideProjectUpdateButton = true;
            var currentRecId = event.currentTarget.dataset.id;
            this.projectId = event.currentTarget.dataset.id;
            var selectName = event.currentTarget.dataset.name;
            this.projectName = event.currentTarget.dataset.name
            this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            this.iconFlag = false;
            this.enableFilter = false;
            this.clearIconFlag = true;
            this.selectRecordName = event.currentTarget.dataset.name;
            //this.ganttProjectValue = event.currentTarget.dataset.Id
            this.selectRecordId = currentRecId;
            this.inputReadOnly = true;
            const selectedEvent = new CustomEvent('selected', { detail: {selectName, currentRecId}, });
            this.dispatchEvent(selectedEvent);
            this.publishMessage(currentRecId, null,false);
        }
        resetData(event){
            this.hideProjectUpdateButton = false;
            this.taskStatusPickList = [];
            this.selectRecordName = "";
            this.selectRecordId = "";
            this.projectId = '';
            this.projectName = '';
            this.inputReadOnly = false;
            this.iconFlag = true;
            this.clearIconFlag = false;
            this.publishMessage(null, null,false);
            this.enableFilter = true;  
        }  
        downloadPdf(){
            this.publishMessage(null, null,true);
        }
        displayToastMessage(title, message){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: title+'!',
                    message: message,
                    variant: title,
                }),
            );  
        } 
    }