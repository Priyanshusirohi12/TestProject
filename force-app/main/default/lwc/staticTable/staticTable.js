import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { createRecord, updateRecord, deleteRecord } from 'lightning/uiRecordApi';
import GanttFiles from '@salesforce/resourceUrl/gantChart';
import JSPdf from '@salesforce/resourceUrl/JSPdf';
import JSPdf2 from '@salesforce/resourceUrl/JSPdf2';
import HTMLCanvas from '@salesforce/resourceUrl/HTMLCanvas';
import RGBColor from '@salesforce/resourceUrl/RGBColor';
import CanvgJS from '@salesforce/resourceUrl/CanvgJS';
import JqueryminJS from '@salesforce/resourceUrl/JqueryminJS';

import exportToPdf from '@salesforce/resourceUrl/exportToPdf';
//import GanttFiles from '@salesforce/resourceUrl/gantt2';
import compareTaskDates from '@salesforce/apex/GanttData.compareTaskDates'; 
import getSprintList from '@salesforce/apex/GanttData.getSprintList';
import deleteTaskRecord from '@salesforce/apex/GanttData.deleteTaskRecord';
import getAllPicklistValues from '@salesforce/apex/GanttData.getAllPicklistValues';
import upsertTask from '@salesforce/apex/GanttData.upsertTask';
import SAMPLEMC from "@salesforce/messageChannel/MyMessageChannel__c"
import getStatusPickListValues from '@salesforce/apex/GanttData.getStatusPickListValues';
import {subscribe, MessageContext, APPLICATION_SCOPE, unsubscribe} from 'lightning/messageService'
import { refreshApex } from '@salesforce/apex';
import ContactMobile from '@salesforce/schema/Case.ContactMobile';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
function unwrap(fromSF){      
    var data = fromSF.map(a =>  ({
        end_start : a.ActivityDate,
        id: a.Id,
        text: a.Subject,
        start_date: a.Start_Date__c,
        duration: a.Duration__c,
        progress: a.Progress__c/100,
        priority :a.Priority,
        status : a.Status,
        end_date : a.ActivityDate,
        ownerId : a.OwnerId,
        owner : a.Owner.Name,
        sprint : a.Sprint__r.Id,
        end_datetime : null,
        start_datetime : null,
        sprintName : a.Sprint__r.Name
    }));                                              
    for(var i in data){
        var endDate = new Date(data[i].end_date); 
        endDate = endDate.toUTCString(); 
        endDate = new Date(endDate);
        endDate.setUTCHours(18);
        endDate.setUTCMinutes(20);
        endDate.setUTCSeconds(0);
        data[i].end_date = endDate

        var startDate = new Date(data[i].start_date); 
        startDate = startDate.toUTCString();
        startDate = new Date(startDate);
        startDate.setUTCHours(-5);
        startDate.setUTCMinutes(-30);
        startDate.setUTCSeconds(0);
        data[i].start_date = startDate;
    }
    console.log('data ',data);
    return { data };
}
function getSprint(sprintList, sprintId){
    var sprints = JSON.parse(JSON.stringify(sprintList))
    const sprintMap = new Map();
    for(var i in sprints){
        sprintMap.set(sprints[i].Id, sprints[i]);
    }
    console.log('dss1',sprints)         
    console.log(sprintMap,' sprintMap1');
    console.log(typeof sprintId,' typeOf');
    if(typeof sprintId === 'object'){
        console.log('hello');
        var selectedSprintList = []
        for(var index in sprintId){
            selectedSprintList.push(sprintMap.get(sprintId[index]));
        }
        return selectedSprintList;
    }else if(typeof sprintId == 'string'){
        return sprintMap.get(sprintId);

    }else{
        return null;
    }              
}
export default class GanttView extends LightningElement {
    statusValue='';
    priorityValue ='';
    @track ownerValue='';
    @track ownerName='';
    sprintValue='';
    startDate ='';
    endDate='';
    subject='';
    taskId;
    progress = 0;
    statusList = [];
    priorityList =[];
    ownerList = [];
    //sprintListForLookup=[];
    showFields = false; 
    activeSections =[];
    @api taskArray = [];
    @track sprintList = [];
    @api height;
    @track isModalOpen = false;
    @track isUpateSprintModelOpen = false;
    ganttInitialized = false;
    @track taskList =[];
    projectId;
    @track statusFilter = [];
    @track projectList = [];
    projectListForDates = [];
    sprintStatusList = [];
    handdleSpinner = false
    isDeleteSprintModalOpen = false
    sprintStatus ='';
    @track sprintName;
    sprintStartDate
    sprintEndDate;
    @track sprintId

    @track ganttProjectId;
    @track ganttProjectName;
    @track objectName;
    
    disabledSprintSaveButton = false;
    disableSprintOnTask = false;
    showOkButton = false;
    toDownloadImg;

    @wire(MessageContext)
    context
    connectedCallback(){
        this.subscribeMessage();
    }

    subscribeMessage(){
        var projectId =  subscribe(this.context, SAMPLEMC, (message) => {this.handleMessage(message)},{scope:APPLICATION_SCOPE});       
    }
    handleMessage(message){
        console.log(message.lmsData.value,' message lms value');
        this.toDownloadImg = message.lmsData.toDownloadImg ? message.lmsData.toDownloadImg : null
        console.log(this.toDownloadImg,' message value');
        console.log(this.statusFilter,' message statusFilterValues');
        if(!this.toDownloadImg){
            this.projectId = message.lmsData.value ? message.lmsData.value : null;
            this.statusFilter = message.lmsData.statusFilterValues ? message.lmsData.statusFilterValues : null
            this.toShowChartOnClick(null, null, this.projectId, this.statusFilter);
        }else if(this.toDownloadImg){
            this.printPdf();
        }
    }
    renderedCallback(){  
         
        if (this.ganttInitialized) {
            return;
        }
            this.ganttInitialized = true;
        Promise.all([
            loadScript(this, GanttFiles + '/dhtmlxgantt.js'),
            loadScript(this, HTMLCanvas),
            loadScript(this, JqueryminJS),
            loadScript(this, RGBColor),
            loadStyle(this, GanttFiles + '/dhtmlxgantt.css'),
            loadScript(this, CanvgJS),
            loadScript(this, JSPdf2)

        ]).then(() => {
            //console.log('exportToPdf ',exportToPdf);
            this.handdleSpinner = true
            this.initializeUI();
        }).catch(error => {
            console.log('gant error',error);
            this.displayToastMessage('No Gantt Load', 'Error loading Gantt', 'error')
        }); 

        Promise.all([
            loadScript(this, JSPdf),    
    
        ]).then(() => {
            console.log('hth2');
            alert('Files loaded.');
            //this.Initializechartjs();
        })
        .catch(error => {
            console.log('error fgfdgdhgdghd',error);
        });
        
    }


    toShowChartOnClick(sprintId, title, projectId, statusFilter){
        console.log('CALLED toShowChartOnClick filters' , statusFilter);  
        if(sprintId == null && projectId != null){
            console.log('CALLED toShowChartOnClick filters 2' , sprintId);
            gantt.clearAll(); 
            getSprintList({projectId : projectId, statusFilter : statusFilter}).then(d => {
                console.log('data r ', d );
                if(d.length == 0){
                    this.displayToastMessage('NO Sprint', 'There is no sprint in this project', 'error');
                }
                this.sprintList = [];       
                this.sprintList = d;
                console.log(this.sprintList, ' sprintList' )
                console.log(this.sprintList.length, ' length' )
                if(this.sprintList.length > 0){
                    this.activeSections = d[0].Id
                    console.log(' activeSections ',this.activeSections)
                    this.taskList = d.length > 0 ? d[0].Activities__r === undefined ? [] : d[0].Activities__r : [];
                    if(this.taskList.length >0){
                        gantt.parse(unwrap(this.taskList));
                    }
                    console.log('hello');
                }
            })
        }
        else if(sprintId == null && projectId == null){      
            this.sprintList = [];
            this.taskList = [];
            gantt.clearAll();
            this.activeSections = []
        }
        else if(this.sprintList.length > 0 && sprintId !=null && title == null){
            gantt.clearAll();     
            //this.sprintListForLookup = []
            getSprintList({projectId : projectId, statusFilter : statusFilter}).then(result => {
                console.log('tasksSprints ', result);

                //var sprint =[];
                // sprint.push({value :'', label : '--None--'})
                // for(var i in result){
                //     var name = result[i].Name;
                //     var id = result[i].Id
                //     sprint.push({value: id, label: name });
                // }
                // this.sprintListForLookup = sprint;

                this.sprintList = result;      
                var sprint = getSprint(this.sprintList, sprintId);
                //this.activeSections = sprintId;
                this.taskList = [];
                if(!(sprint === undefined)){
                    for(var index in sprint){
                        for(var i in sprint[index].Activities__r){
                            this.taskList.push(sprint[index].Activities__r[i])
                        }
                    }
                    console.log('taskssss112 ',this.taskList);
                    gantt.parse(unwrap(this.taskList));
                }
            })
        }
        else if(this.sprintList.length > 0 && sprintId !=null && title == 'Press down'){
            console.log('fdfsdfs');
            gantt.clearAll(); 
            console.log('if ', sprintId);
            getSprintList({projectId : projectId, statusFilter : statusFilter}).then(result => {
                console.log('tasksSprints ', result);
                this.sprintList = result;
            })
            console.log(this.sprintList +'sprintgf ')
            var sprint = getSprint(this.sprintList, sprintId);
            this.activeSections = sprintId;         
            console.log('sprint ',sprint);
            this.taskList = [];
            if(!(sprint === undefined)){
                for(var index in sprint){
                    for(var i in sprint[index].Activities__r){
                        this.taskList.push(sprint[index].Activities__r[i])
                    }
                }
                gantt.parse(unwrap(this.taskList));
            }      
        }            
    }
    initializeUI(){
        var tArray = this.taskArray; 
        
        const root = this.template.querySelector('.thegantt');
        gantt.config.columns = [
            // {name:"text",       label:"Task name",  width:"*", tree:true },
            // {name:"start_date", label:"Start time", align:"center", width:"*", tree:true},
            // {name:"duration",   label:"Duration",   align:"center" },
            // {name:"status", label:"status", align:"center"},
            //{name:"add", label:"", width:44 }   
        ];
        //gantt.config.row_height = 40;
 


        root.style.height = this.height + "px";
        gantt.templates.parse_date = date => new Date(date);      
        gantt.templates.format_date = date => date.toISOString();
        gantt.init(root);  
        this.handdleSpinner = false
        gantt.templates.task_class  = function(start, end, task){
            switch (task.priority){
                case "High":
                    return " high";
                case "Normal":
                    return " normal";
                case "Low":
                    return " low";
            }
        };

        var status = [];
        var priority =[];
        var owner = [];
        //var sprint =[];
        getAllPicklistValues().then(result=>{
            status.push({value :'', label : '--None--'})
            for(var i in result.data0){
                status.push({value: result.data0[i], label: result.data0[i]});
            }
            this.statusList = status

            priority.push({value :'', label : '--None--'})
            for(var i in result.data1){
                priority.push({value: result.data1[i], label: result.data1[i]});
            }
            this.priorityList = priority;
            owner.push({value :'', label : '--None--'})
            for(var i in result.data2){
                var name = result.data2[i].split('& ')[0];
                var id = result.data2[i].split('& ')[1];
                owner.push({value: id, label: name });
            }
            this.ownerList = owner
            // sprint.push({value :'', label : '--None--'})
            // for(var i in result.data4){
            //     var name = result.data4[i].split('& ')[0];
            //     var id = result.data4[i].split('& ')[1];
            //     sprint.push({value: id, label: name });
            // }
            // this.sprintListForLookup = sprint;
        })

        gantt.locale.labels.section_priority = "Priority";
        gantt.locale.labels.section_status = "Status"; 
        gantt.locale.labels.section_owner = "Owner"; 
        gantt.locale.labels.section_sprint = "Sprint";
        gantt.config.lightbox.sections = [
            {name: "description", height: 38,  map_to: "text", type: "textarea", focus: true},
            {name: "priority", height:22, map_to:"priority", type:"select", options: priority},
            {name: "status", height: 22, map_to: "status", type: "select", options: status}, 
            {name: "owner", height: 22, map_to:"owner", type:"select", options:  owner},
            {name: "sprint", height: 22, map_to:"sprint", type:"select", options:  sprint},
            {name: "time", type: "duration", map_to: "auto"}
        ];
        gantt.templates.progress_text=function(start, end, task){
            var taskProgress = task.progress*100;
            taskProgress = taskProgress.toString();
            taskProgress = taskProgress.split('.')[0];
            return taskProgress+'%';
        };       
        gantt.attachEvent("onTaskDblClick", (id, e) => {
            const taskobject = gantt.getTask(id);
            //console.log('taskobject ', taskobject);
            this.openModal(taskobject);
        });
        const self = this;
        gantt.attachEvent("onTaskDblClick", function(id, e) {
            const taskobject = gantt.getTask(id);
            //console.log('taskobject ', taskobject);
            self.openModal(taskobject);
        }); 
        var beforeTaskDragStartDate;
        var beforeTaskDragEndDate
        gantt.attachEvent("onBeforeTaskDrag", function(id, mode, e){
            const taskObject = gantt.getTask(id);
            console.log('taskobject ',taskObject)
            beforeTaskDragStartDate = taskObject.start_date;
            beforeTaskDragEndDate = taskObject.end_date;
            console.log('beforeTaskDragStartDate ',beforeTaskDragStartDate);
            console.log('beforeTaskDragEndDate ',beforeTaskDragEndDate);
            return true;
        });
        var sprint
        gantt.attachEvent("onTaskDrag", (id, mode, task, original)=>{
            sprint = getSprint(this.sprintList, task.sprint) 
           // console.lg('sprintList according to get sprint ', sprint);
            var modes = gantt.config.drag_mode;
            if(mode == modes.move || mode == modes.resize){
                var diff = original.duration*(1000*60*60*24);
                sprint.Start_Date__c = new Date(sprint.Start_Date__c).setUTCHours(-5);
                sprint.Start_Date__c = new Date(sprint.Start_Date__c).setUTCMinutes(-30)
                sprint.End_Date__c = new Date(sprint.End_Date__c).setUTCHours(18);
                sprint.End_Date__c = new Date(sprint.End_Date__c).setUTCMinutes(28)
                console.log(' task1221 ',task.start_date);
                var taskEndDate = task.end_date;
                //taskEndDate.setDate(taskEndDate.getDate() - 1); 
                console.log(' task122122 ',taskEndDate);
                console.log(' task.end_date ',task.end_date);
                console.log('new Date(sprint.End_Date__c) ', new Date(sprint.End_Date__c))
                
                console.log(new Date(sprint.End_Date__c),' new Date(sprint.End_Date__c)');
                console.log(new Date(sprint.Start_Date__c),' new Date(sprint.Start_Date__c)');

                if(task.end_date > new Date(sprint.End_Date__c)){
                    //task.end_date = new Date(sprint.End_Date__c);
                    task.end_date = beforeTaskDragEndDate
                    if(mode == modes.move)
                        //task.start_date = new Date(sprint.Start_Date__c);
                        task.start_date = beforeTaskDragStartDate
                        //this.displayToastMessage('error', 'task end date should be below then '+new Date(sprint.End_Date__c));
                        var endDate = new Date(sprint.End_Date__c).toString().split(' 23:')[0]
                        console.log(endDate)
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error!',
                                message: 'End date should be below then '+endDate ,
                                variant: 'error',
                            }),
                        );
                }
                else if(task.start_date < new Date(sprint.Start_Date__c)){
                    console.log('hye');
                    //task.start_date = new Date(sprint.Start_Date__c);
                     task.start_date = beforeTaskDragStartDate
                    if(mode == modes.move)
                        //task.end_date = new Date(sprint.End_Date__c);
                        task.end_date = beforeTaskDragEndDate
                    //this.displayToastMessage('error', 'task start date should be above then '+new Date(sprint.Start_Date__c))
                    var startDate = new Date(sprint.Start_Date__c).toString().split(' 00:')[0]
                    this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error!',
                                message: 'task start date should be above then '+startDate,
                                variant: 'error',
                            }),
                    );
                }
            }
            //console.log(task,' task222')
            //console.log(original,' original')
        })
        const self2 = this;
        gantt.attachEvent("onTaskDrag", function(id, mode, task, original) {
                self2.sprintList;
                self2.dispatchEvent;
                //self2.displayToastMessage('', '');
         })
        gantt.createDataProcessor({
            task: {
                create: function(data) {
                    console.log('data12 ',data);
                    var startDate =  data.start_date; //.split('T')[0];
                    var date =  data.end_date //.split('T')[0];
                    //startDate.setDate(startDate.getDate() + 1);
                    var fields = {
                        Id: null,
                        Subject : data.text,
                        Start_Date__c : startDate,
                        Duration__c : data.duration,
                        ActivityDate : date,
                        Priority : data.priority,
                        Status : data.status,
                        Progress__c : 0,
                        OwnerId : data.ownerId,
                        Sprint__c : data.sprint
                    };
                    console.log(fields, 'data ');
                     return upsertTask({task : fields}).then(res=>{
                         console.log('result1 ',res);
                         return { tid: 1, ...res};
                     }).catch(error=>{
                         console.log(error);
                     })
                },
                update: function(data, id) {
                    console.log('data12 ',data);
                    var startDate = data.start_date.split('T')[0];
                    startDate = new Date(startDate);
                    startDate.setDate(startDate.getDate() + 1);             
                    var date =  data.end_date.split('T')[0];
                    //console.log('taskList',self.taskList);
                    var fields = {
                        Id: id,
                        Subject : data.text,
                        Start_Date__c : startDate,
                        Duration__c : data.duration,
                        ActivityDate : date,
                        Progress__c : data.progress * 100,
                        Priority : data.priority,
                        Status : data.Status,
                        OwnerId : data.ownerId,
                        Sprint__c : data.sprint
                    }
                    console.log('task in update ', fields);
                    var sprint = getSprint(self.sprintList,fields.Sprint__c);
                    if(new Date(fields.Start_Date__c) > new Date(fields.ActivityDate)){

                        self.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error!',
                                message: 'Start date should not be greater then end date ',
                                variant: 'error',
                            }),
                        );
                        fields.ActivityDate = fields.Start_Date__c;
                        fields.Duration__c = 1;
                        upsertTask({task :fields}).then(result => {
                            console.log('updated result 1 ',result);
                            self.toShowChartOnClick(self.activeSections, null, self.projectId, self.statusFilter);
                            return result;
                        });
                    }else if(new Date(fields.Start_Date__c) <= new Date(fields.ActivityDate)){
                        if(fields.Start_Date__c >= new Date(sprint.Start_Date__c) && new Date(fields.ActivityDate) <= new Date(sprint.End_Date__c)){
                            upsertTask({task :fields}).then(result => {
                                console.log('updated result 2 ',result);
                                self.toShowChartOnClick(self.activeSections, null, self.projectId, self.statusFilter);
                                return result;
                            });
                        }
                    }
                    
                    /*else if(new Date(fields.ActivityDate) > new Date(sprint.End_Date__c)){
                        console.log('sprint 4');
                        gantt.message({type:"error", text:"End date should be below then "+sprint.End_Date__c+" date"});
                        return false;
                    }  
                    else if(fields.Start_Date__c < new Date(sprint.Start_Date__c)){
                        console.log('sprint 3');
                        gantt.message({type:"error", text:"Start date should be above then "+sprint.Start_Date__c+" date"});
                        return false;
                    }*/
                },
                delete: function(id) {
                    console.log('task deleted record id ', id);
                     return deleteTask({id : id}).then(result => {
                        console.log('result ',result);
                    }).catch(error =>{
                        console.log(error);
                    });
                }
            },
            link: {
                create: function(data) {
                    console.log('link ', data);
                    const insert = { apiName: "GanttLink__c", fields:{
                        Source__c : data.source,
                        Target__c : data.target,
                        Type__c : data.type,
                    }};
                    return createRecord(insert).then(res => {
                        return { tid: res.id };
                    });
                },
                update: function(data, id) {
                    const update = { apiName: "GanttLink__c", fields:{
                        Id : id,	
                        Source__c : data.source,
                        Target__c : data.target,
                        Type__c : data.type,
                    }};
                    return updateRecord(update).then(() => ({}));
                },
                delete: function(id) {
                    return deleteRecord(id).then(result => {
                        console.log('result ',result);
                    }).catch(error =>{
                        console.log(error);
                    });
                }
            }
        }).init(gantt);
    }
    handleToggleSection(event) {
        console.log('title 1 '+ event.target.title);
        console.log('event.detail.openSections ',event.detail.openSections);
        this.activeSections = event.detail.openSections;
        this.toShowChartOnClick(this.activeSections, event.target.title, this.projectId, this.statusFilter);
    }

    handleProgressValueChange(event){
        console.log('Id ', event.detail.Id);
        console.log('Name ', event.detail.Name);
        console.log('Object ', event.detail.objectName);
        if(event.detail.objectName == 'Gantt_Project__c'){
            this.ganttProjectId = event.detail.Id;
            this.ganttProjectName = event.detail.Name;
        }else if(event.detail.objectName == 'Sprint__c' && event.detail.user ==''){
            this.sprintValue = event.detail.Id;
            this.sprintName = event.detail.Name;
        }else if(event.detail.objectName == 'Sprint__c' && event.detail.user =='User'){
            this.ownerName = event.detail.Name;
            this.ownerValue = event.detail.Id;
        }
    }

    openModelForUpdateTask(event){
        this.objectName ="Sprint__c"
        this.disabledSprintSaveButton = false;
        this.showFields = true;
        this.disableSprintOnTask = false;
        this.isModalOpen = true;
        console.log('event ',event.target.value);
        //var taskObject = this.taskList[event.currentTarget.dataset.index];
        var taskObject= this.taskList.filter(result =>{return result.Id.indexOf(event.target.value) != -1})
        taskObject = taskObject[0];

        this.sprintValue = taskObject.Sprint__c;
        this.sprintName = taskObject.Sprint__r.Name;
        
        console.log('taskObject ',taskObject);
        this.taskId = taskObject.Id;
        this.statusValue = taskObject.Status;
        this.priorityValue = taskObject.Priority;
        this.ownerValue = taskObject.OwnerId;
        this.ownerName =taskObject.Owner.Name;
        //this.sprintValue = taskObject.Sprint__c;
        this.startDate = taskObject.Start_Date__c;
        this.endDate = taskObject.ActivityDate;
        this.subject = taskObject.Subject;
        this.progress = taskObject.Progress__c.toString().split('.')[0];     
    }

    openModalForInsertTask(event){

        this.sprintValue = event.target.value;
        var sprintObject= this.sprintList.filter(result =>{return result.Id.indexOf(event.target.value) != -1})
        sprintObject = sprintObject[0];
        console.log('sprintObject ', sprintObject)
        this.sprintName = sprintObject.Name;
        this.objectName ="Sprint__c"
        // getSprintList({projectId : this.projectId}).then(result => {
        //     console.log('tasksSprints ', result);
        //     var sprint =[];
        //     sprint.push({value :'', label : '--None--'})
        //     for(var i in result){
        //         var name = result[i].Name;
        //         var id = result[i].Id
        //         sprint.push({value: id, label: name });
        //     }
        //     this.sprintListForLookup = sprint;
        // })
        console.log('event ',event.target.value)
        this.disabledSprintSaveButton = false;
        this.isModalOpen = true;
        this.taskId = null;
        this.statusValue = '';
        this.priorityValue = '';
        this.ownerValue = '';
        this.ownerName = '';
        this.startDate = '';
        this.endDate = '';
        this.subject = '';
        this.progress = 0;   
        //this.sprintValue = event.target.value;
        this.showFields = false; 
        this.disableSprintOnTask = true;
    }

    contactChangeVal(event) {
        console.log(event.target.label);
        console.log(event.target.value);        
        if(event.target.label=='Subject'){
            this.subject = event.target.value;
        }
        if(event.target.label=='Priority'){
            this.priorityValue = event.target.value;
            
        }            
        if(event.target.label=='Status'){
            this.statusValue = event.target.value;
        }
        // if(event.target.label=='Owner'){
        //     this.ownerValue = event.target.value;
        // }
        // if(event.target.label=='Sprint'){
        //     this.sprintValue = event.target.value;
        // }
        if(event.target.label=='Start Date'){
            this.startDate = event.target.value;
        }
        if(event.target.label=='Progress'){
            this.progress = event.target.value;
            console.log('Progress ' ,this.progress);
        } 
        if(event.target.label=='End Date'){
            this.endDate = event.target.value;
        }            
    }
    upsertTaskAction(){
        var startDate = new Date(this.startDate);
        var endDate = new Date(this.endDate);
        var diffDays = Math.ceil(Math.abs(endDate - startDate) / (1000 * 60 * 60 * 24)) +1; 
        const fields = {
            Id : this.taskId,
            Status : this.statusValue,
            Subject : this.subject,
            Priority : this.priorityValue,
            Progress__c : this.progress,
            OwnerId : this.ownerValue,
            Sprint__c : this.sprintValue,
            Start_Date__c : this.startDate,
            ActivityDate : this.endDate,
            Duration__c : diffDays
        };
        console.log(fields, 'fields');
        
        if(fields.Subject != null && fields.Subject != '' && /\S/.test(fields.Subject) 
            && fields.Priority != null && fields.Priority != '' && fields.Progress__c != null 
            && fields.OwnerId != null && fields.OwnerId != '' && fields.Sprint__c != null 
            && fields.Sprint__c != '' && fields.ActivityDate != '' && fields.ActivityDate != null 
            && fields.Status != null && fields.Status !='' && fields.Duration__c != NaN 
            && fields.Start_Date__c != null  && fields.Start_Date__c != ''){
                
            var sprint = getSprint(this.sprintList, fields.Sprint__c);
            var sprintStartDate = sprint.Start_Date__c;
            var sprintEndDate = sprint.End_Date__c;
            if(!(startDate <= endDate)){
                this.displayToastMessage('Date compare Error', 'End date should be greater then Start  date','error')         
            }else if(fields.Progress__c > 100){
                this.displayToastMessage('Progress Error', 'Progress should be under 100 or equal to 100', 'error')
            }else{
                console.log('sprintEndDate ', new Date(sprintEndDate));
                console.log('end ', endDate);
                if(startDate >= new Date(sprintStartDate) && endDate <=  new Date(sprintEndDate)){
                    console.log('start ',startDate);
                    console.log('end ', endDate);
                    this.handdleSpinner = true;
                    upsertTask({task :fields}).then(result => {
                        console.log('updated result ',result);   
                        this.disabledSprintSaveButton = true;
                        this.isModalOpen = false;
                        this.handdleSpinner = false;
                        this.displayToastMessage('Success ', 'Record is successfully upsert','success');
                        this.toShowChartOnClick(this.activeSections, null, this.projectId, this.statusFilter);
                        console.log(result.Sprint__c, ' sprint');
        
                    }).catch(error =>{
                        console.log('task not update ', error);
                    });      
                }       
                else if(startDate < new Date(sprintStartDate)){
                    var sprintSDate = new Date(sprintStartDate).toString().split(' 05:')[0];
                    this.displayToastMessage('Start date Error', 'Start date should be later or equal to sprint start date ('+sprintSDate +')', 'error')
                }else if(endDate > new Date(sprintEndDate)){
                    var sprintEDate = new Date(sprintEndDate).toString().split(' 05:')[0];
                    this.displayToastMessage('End date Error', 'End date should be below or equal to sprint end date ('+sprintEDate +')', 'error');
                }    
            }
        }else {
            this.displayToastMessage('Error', 'Fill the required fields', 'error');
            
        }
    }
    closeModal() {
        this.isModalOpen = false;
        this.isUpateSprintModelOpen = false;
        this.isDeleteSprintModalOpen = false;
    }
    openModal(taskObject){
        console.log('taskObject ',taskObject)
        this.objectName = 'Sprint__c';
        var date = taskObject.start_date.setUTCHours(5);
        date = new Date(date);
        this.isModalOpen = true;
        this.showFields = true;
        this.disableSprintOnTask = false;
        var taskProgress = taskObject.progress*100;
        taskProgress = taskProgress.toString();
        taskProgress = taskProgress.split('.')[0];
        var endDate = new Date(taskObject.end_date).toISOString().slice(0, 10);
        //taskObject.start_date.setDate(taskObject.start_date.getDate() + 1);
        var startDate = new Date(taskObject.start_date)
        startDate.setDate(taskObject.start_date.getDate() +1);
        startDate = startDate.toISOString().slice(0, 10);
        this.taskId = taskObject.id;
        this.statusValue = taskObject.status;
        this.priorityValue = taskObject.priority;
        this.ownerValue = taskObject.ownerId;
        this.ownerName = taskObject.owner;
        this.sprintValue = taskObject.sprint;
        this.sprintName = taskObject.sprintName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.subject = taskObject.text;
        this.progress = taskProgress;
    }

    openModalToUpdateSprint(event){
        this.objectName = 'Gantt_Project__c';
        console.log('event.target.value ' ,event.target.value)
        this.disabledSprintSaveButton = false;
        getStatusPickListValues().then(result=>{
            var sprintStatusList= [];
            sprintStatusList.push({label : '--None--', value : ''});
            for(var index in result.picklistValues){
                sprintStatusList.push({label : result.picklistValues[index], value : result.picklistValues[index]})
            }
            this.sprintStatusList = sprintStatusList;
            this.projectListForDates = result.projectList
            //console.log(this.sprintStatusList, 'sprintListStatus');
            //var projectList =[]
           
            // for(var i in result.projectList){  
            //     projectList.push({label : result.projectList[i].Name, value : result.projectList[i].Id})
            // }
            // this.projectList = projectList; 
        });
        this.isUpateSprintModelOpen = true;
        var sprintObject = this.sprintList.filter(result=>{return result.Id.indexOf(event.target.value) !== -1}) 
        sprintObject = sprintObject[0];
        console.log('sprintObject 1',sprintObject);
        this.sprintId = event.target.value;
        this.sprintStatus = sprintObject.Status__c
        this.sprintName = sprintObject.Name
        this.sprintStartDate = sprintObject.Start_Date__c
        this.sprintEndDate = sprintObject.End_Date__c
        this.ganttProjectId = sprintObject.Gantt_Project__c
        this.ganttProjectName = sprintObject.Gantt_Project__r.Name
    }

    sprintChangeValue(event) {   
        console.log('gfdgdf', event.target.label);    
        if(event.target.label=='Name'){
            this.sprintName = event.target.value;
        }
        if(event.target.label=='Status'){
            this.sprintStatus = event.target.value; 
        }            
        // if(event.target.label=='Gantt Project'){
        //     this.ganttProjectId = event.target.value;
        // }
        if(event.target.label=='Start Date'){
            this.sprintStartDate = event.target.value;
        }
        if(event.target.label=='End Date'){
            this.sprintEndDate = event.target.value;
        }            
    }
    isSprintDataFill(diffDays){
        if(this.sprintId != null && this.sprintId != '' && diffDays != null && this.sprintStatus != '' 
            && this.sprintStatus != null && this.sprintName != '' && this.sprintName != null && /\S/.test(this.sprintName) 
            && this.sprintStartDate != null && this.sprintStartDate != '' && this.sprintEndDate != null 
            && this.sprintEndDate != '' && this.ganttProjectId != null && this.ganttProjectId !='' ){
            return true;
        }else{
            return false
        }  
    }

    updateSprint(){
        var diffDays =  null; 
        if(this.sprintStartDate != null && this.sprintEndDate != null){
            var startDate = new Date(this.sprintStartDate);
            var endDate = new Date(this.sprintEndDate);
            diffDays = Math.ceil(Math.abs(endDate - startDate) / (1000 * 60 * 60 * 24)) +1;  
            console.log(diffDays, 'diffDays')
        }

        console.log(diffDays, 'diffDays')
        console.log('startDate ' ,startDate);
        console.log('startDate ' ,endDate);
        console.log(this.sprintId);
        const update= { fields:{
            Id : this.sprintId,	
            Name : this.sprintName,
            Start_Date__c : this.sprintStartDate,
            End_Date__c : this.sprintEndDate,
            Gantt_Project__c : this.ganttProjectId,
            Status__c : this.sprintStatus,
            Duration__c : diffDays
        }};
        console.log('update ',update);
        console.log(this.projectListForDates, ' projectListForDates');
        var projectObject = this.projectListForDates.filter(result=>{return result.Id.indexOf(this.ganttProjectId) !== -1})
        // var sprintObject = this.sprintList.filter(result=>{return result.Id.indexOf(event.target.value) !== -1}) 
        projectObject = projectObject[0];
        console.log(projectObject, ' projectObject')

        
        if(this.isSprintDataFill(diffDays)){
            if(!(this.sprintStartDate <= this.sprintEndDate)){
                this.displayToastMessage('Compaire Date Error', 'Start date should be below then end date', 'error');
            }
            else if(new Date(projectObject.Start_Date__c) > new Date(this.sprintStartDate)){
                var projectStartDate = new Date(projectObject.Start_Date__c).toString().split(' 05:')[0];              
                this.displayToastMessage('Start date Error', 'Sprint start date should be later or equal to project start date ('+projectStartDate+')', 'error');
            }else if(new Date(projectObject.End_Date__c) < new Date(this.sprintEndDate)){
                var projectEndDate = new Date(projectObject.End_Date__c).toString().split(' 05:')[0];
                this.displayToastMessage('End date Error', 'Sprint end date should be below or equal to project end date ('+projectEndDate+')', 'error');
            }else{
                var taskDates;
                console.log('sprintId ', this.sprintId);
                compareTaskDates({sprintId : this.sprintId}).then(result=>{
                    console.log('result ',result)
                    taskDates = result;
                    if(taskDates != null){
                        if(new Date(taskDates.minStartDate) < new Date(this.sprintStartDate)){
                            var projectStartDate = new Date(taskDates.minStartDate).toString().split(' 05:')[0];
                            this.displayToastMessage('Date Error', 'Task are exist with lower start date on this Sprint (lowest Task start date is '+projectStartDate+')',  'error');        
                        }else if(new Date(taskDates.maxEndDate) > new Date(this.sprintEndDate)){
                            var projectEndDate = new Date(taskDates.maxEndDate).toString().split(' 05:')[0];
                            this.displayToastMessage('Date Error', 'Task are exist with higher end date on this Sprint (highest Task end date is '+projectEndDate,  'error'); 
                        }else if(new Date(taskDates.minStartDate) >= new Date(this.sprintStartDate) || new Date(taskDates.maxEndDate) <= new Date(this.sprintEndDate)){
                            this.handdleSpinner = true;
                            updateRecord(update).then(result=>{
                                this.isUpateSprintModelOpen = false;
                                this.handdleSpinner = false;
                                this.disabledSprintSaveButton = true;
                                this.toShowChartOnClick(this.activeSections, null, this.projectId, this.statusFilter);
                                this.displayToastMessage('Success', 'The Record is Updated','success')
                            }) 
                        }
                    }else{
                        this.handdleSpinner = true;
                        updateRecord(update).then(result=>{
                            this.isUpateSprintModelOpen = false;
                            this.handdleSpinner = false;
                            this.disabledSprintSaveButton = true;
                            this.toShowChartOnClick(this.activeSections, null, this.projectId, this.statusFilter);
                            this.displayToastMessage('Success', 'The Record is Updated','success')
                        }) 
                    }
                })
            }
        }else{
            this.displayToastMessage('Required fields Error', 'Fill the required fields','error');
        }      
    }
    openModalForDeleteSprint(event) {
        this.isDeleteSprintModalOpen = true;
        console.log('title',event.target.title);
        if(event.target.title == 'Delete Sprint'){
            this.sprintId = event.target.value;
            this.showOkButton = true;
        } 
        else if(event.target.title == 'Delete Task'){
            this.taskId = event.target.value;
            this.showOkButton = false;
        }  
    }
    handleDeleteTask(){
        this.handdleSpinner =true
            //deleteRecord(this.taskId)
            // .then(() => {
            //     this.handdleSpinner = false
            //     this.displayToastMessage('Success', 'Record Deleted', 'success');
            //     this.toShowChartOnClick(this.activeSections, null, this.projectId, this.statusFilter); 
            //     this.isDeleteSprintModalOpen = false;
            // })
            console.log('task deleted record id ', this.taskId);
            deleteTaskRecord({id : this.taskId}).then(result => {
                        this.handdleSpinner = false
                        this.displayToastMessage('Success', 'Record Deleted', 'success');
                        this.toShowChartOnClick(this.activeSections, null, this.projectId, this.statusFilter); 
                        this.isDeleteSprintModalOpen = false;
                        console.log(result);
                    }).catch(error =>{
                        this.handdleSpinner = false
                        this.displayToastMessage('Error in Delete', 'Record not Delete', 'error');
                        console.log(error);
                    });
    }
    handleDeleteSprint(){
        this.handdleSpinner =true
        deleteRecord(this.sprintId)
            .then(() => {
                this.handdleSpinner = false
                this.displayToastMessage('Success', 'Record Deleted', 'success');
                this.toShowChartOnClick(null, null, this.projectId, this.statusFilter); 
                this.isDeleteSprintModalOpen = false;
            })
    }
    displayToastMessage(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );  
    }

    printPdf(){
        //var nodesToRecover = []
        var targetElem = this.template.querySelector(".printPdf"); // Select the element which needs to printed in pdf format
        var nodesToRemove = []
        var svgs = $(targetElem).find('svg');
        console.log('canvas 1 ',svgs);
        svgs.each(function(index, node) {
            console.log('node ', node);
            console.log('node.parentNode ', node.parentNode);
            console.log('parentNode.innerHTML ', node.parentNode.innerHTML);
            var parentNode = node.parentNode
            var svg = parentNode.innerHTML
            var canvas = document.createElement('canvas')
            console.log('index  ', index);
            console.log('canvas  ', canvas);
            console.log('svg  ', svg);
            //var xml = new XMLSerializer().serializeToString(node)
            //xml = xml.replace(/xmlns=\"http:\/\/www\.w3\.org\/2000\/svg\"/, '')
            //canvg(canvas, svg); // html to image
            canvg.fromString(canvas, svg);
            nodesToRecover.push({ 
                parent: parentNode,
                child: node
             })
            parentNode.removeChild(node)
            nodesToRemove.push({
            parent: parentNode,
                child: canvas
            })
            console.log('canvas 4',canvas);
            parentNode.appendChild(canvas)
        })
        
        if(this.taskList.length >0){
            html2canvas(targetElem, {
                onrendered: function(canvas) {
                canvas.style.visibility = 'hidden'
                document.body.appendChild(canvas);
                // canvas.toBlob(
                //     blob => {
                //       // do something with the blob here...
                //     },
                //     'image/jpeg',
                //     0.9,
                //   );
                var doc = new jsPDF('p', 'pt', [canvas.height,canvas.width]); // create pdf file
                console.log('doc ',doc)
                doc.addHTML(canvas, {}, function() { // add image to pdf file  
                    //canvas.toBlob(canvas, 'image/png', 1);
                    var binaryString = window.atob(btoa(doc.output()));
                    var binaryLen = binaryString.length;
                    var bytes = new Uint8Array(binaryLen);
                    for (var i = 0; i < binaryLen; i++) {
                        var ascii = binaryString.charCodeAt(i);
                        bytes[i] = ascii;
                    }
                    var blob = new Blob([bytes],{type : "application/pdf"});
                    var link = document.createElement("a");
                    link.href = window.URL.createObjectURL(blob);
                    link.download = 'gantt chart';
                    link.click(); 
                        document.body.removeChild(canvas)
                    })
                }
            })
        }else if(this.taskList.length <= 0){
            this.displayToastMessage('No Task', 'There is no task in chart', 'Error')
        }  
    }
}