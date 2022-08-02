/* eslint-disable guard-for-in */
import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { createRecord, updateRecord, deleteRecord } from 'lightning/uiRecordApi';
import GanttFiles from '@salesforce/resourceUrl/gantChart';
//import GanttFiles from '@salesforce/resourceUrl/ganttFiles';
import getTasks from '@salesforce/apex/GanttData.getTasks';
import deleteTask from '@salesforce/apex/GanttData.deleteTask';
import getAllPicklistValues from '@salesforce/apex/GanttData.getAllPicklistValues';
import upsertTask from '@salesforce/apex/GanttData.upsertTask';
import StartDate from '@salesforce/schema/Contract.StartDate';
function unwrap(fromSF){  
     
    const data = fromSF.tasks.map(a => ({
        end_start : a.ActivityDate,
        id: a.Id,
        text: a.Subject,
        start_date: a.Start_Date__c,
        duration: a.Duration__c,
        //parent: null,
        //progress: null,
        priority :a.Priority,
        status : a.Status,
        end_date : a.ActivityDate,
        ownerId : a.Owner.Id,
        owner : a.Owner.Id,
        sprint : a.Sprint__r.Id,
        //open:true,
        parent : 'a0O5g0000002uCQEAY'//a.Sprint__c
    }));                                                       
    data.push({id:"a0O5g0000002uCQEAY", text:"xyz", start_date:"09-03-2021", duration:5,  open:true})
    data.push({id:"p_1", text:"Project #1", start_date:"01-04-2020", duration:18, open:true});
    data.push({id:"t_1", text:"Task #1", start_date:"02-04-2020", duration:8, parent:"t_3"})
    data.push({id:"t_2", text:"Task #2", start_date:"11-04-2020", duration:8,parent:"p_1"})
    data.push({id:"t_3", text:"Task #3", start_date:"11-04-2020", duration:10,})
    data.push({id:"t_5", text:"Task #2", start_date:"11-04-2020", duration:8, parent:"t_3"})
    data.push({id:"a0O5g0000002vE2EAI", text:"dc", start_date:"09-03-2021", duration:5,  open:true})
    console.log('data12 ',data);
    const links = fromSF.links.map(a => ({
        id: a.Id,
        source: a.Source__c,
        target: a.Target__c,
        type: a.Type__c
    }));  
    //gantt.open('00T5g00000Mz7krEAB');
    return { data, links };
}


export default class GanttView extends LightningElement {
    @api taskArray = [];
    @api height;
    ganttInitialized = false;
    renderedCallback() {
        if (this.ganttInitialized) {
            return;
        }
        this.ganttInitialized = true;
        Promise.all([
            loadScript(this, GanttFiles + '/dhtmlxgantt.js'),
            loadStyle(this, GanttFiles + '/dhtmlxgantt.css'),
        ]).then(() => {
            console.log('hi ');
            this.initializeUI();
        }).catch(error => {
            console.log('gant error');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading Gantt',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }

    initializeUI(){
        var tArray = this.taskArray; 
        const root = this.template.querySelector('.thegantt');
        gantt.config.columns = [
            {name:"text",       label:"Task name",  width:"*", tree:true },
            {name:"start_date", label:"Start time", align:"center"},
            {name:"duration",   label:"Duration",   align:"center" },
            {name:"status", label:"status", align:"center"},
            {name:"add", label:"", width:44 }   
        ];

        root.style.height = this.height + "px";
        gantt.templates.parse_date = date => new Date(date);      
        gantt.templates.format_date = date => date.toISOString();
        gantt.init(root);  

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
        var sprint =[];

        getAllPicklistValues().then(result=>{
            status.push({key :'', label : '---------Select Any Option------------'})
            for(var i in result.data0){
                status.push({key: result.data0[i], label: result.data0[i]});
            }

            priority.push({key :'', label : '---------Select Any Option------------'})
            for(var i in result.data1){
                priority.push({key: result.data1[i], label: result.data1[i]});
            }
            owner.push({key :'', label : '---------Select Any Option------------'})
            for(var i in result.data2){
                var name = result.data2[i].split('& ')[0];
                var id = result.data2[i].split('& ')[1];
                owner.push({key: id, label: name });
            }
            console.log('result.data4) ',result.data4);

            sprint.push({key :'', label : '---------Select Any Option------------'})
            for(var i in result.data4){
                var name = result.data4[i].split('& ')[0];
                var id = result.data4[i].split('& ')[1];
                sprint.push({key: id, label: name });
            }
            console.log('sprint ', sprint);
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

        getTasks().then(d => {
            //console.log('getTasks called' , d);
            var taskData = [];
            var sprintObject;
            for(var i in d.tasks){
                sprintObject = {}
                if(d.tasks[i].hasOwnProperty('Sprint__c') && d.tasks[i].hasOwnProperty('Sprint__c')){
                    sprintObject = {
                        ActivityDate : d.tasks[i].ActivityDate,
                        Duration__c : d.tasks[i].Duration__c,
                        Id : d.tasks[i].Id,
                        Owner : d.tasks[i].Owner,
                        OwnerId : d.tasks[i].OwnerId,
                        Priority : d.tasks[i].Priority,
                        Sprint__c : d.tasks[i].Sprint__c,
                        Sprint__r : d.tasks[i].Sprint__r,
                        Start_Date__c : d.tasks[i].Start_Date__c,
                        Status : d.tasks[i].Status,
                        Subject : d.tasks[i].Subject,
                    }
                    taskData.push(sprintObject);
                }
                else if(!d.tasks[i].hasOwnProperty('Sprint__c') && !d.tasks[i].hasOwnProperty('Sprint__c')){
                    sprintObject = {
                        ActivityDate : d.tasks[i].ActivityDate,
                        Duration__c : d.tasks[i].Duration__c,
                        Id : d.tasks[i].Id,
                        Owner : d.tasks[i].Owner,
                        OwnerId : d.tasks[i].OwnerId,
                        Priority : d.tasks[i].Priority,
                        Sprint__c : null, //d.task[i].Sprint__c,
                        Sprint__r : {Name : null, Id :null}, 
                        Start_Date__c : d.tasks[i].Start_Date__c,
                        Status : d.tasks[i].Status,
                        Subject : d.tasks[i].Subject,
                    }
                    taskData.push(sprintObject);
                }   
            }
            console.log('taskfff ',taskData);
            d.tasks.map(task => {
                tArray[task.Id] = task;
            });
            d.tasks = [];
            d.tasks = taskData;
            gantt.parse(unwrap(d));
            gantt.hasChild("p_1"); //-> true  
            //gantt.hasChild("t_1"); //-> false 

            // var data = {
            //     tasks:[
            //        {id:"p_1", text:"Project #1", start_date:"01-04-2020", duration:18, 
            //        open:true},
            //        {id:"t_1", text:"Task #1", start_date:"02-04-2020", duration:8,
            //        parent:"t_3"},
            //        {id:"t_2", text:"Task #2", start_date:"11-04-2020", duration:8,
            //        parent:"p_1"},
            //        {id:"t_3", text:"Task #3", start_date:"11-04-2020", duration:10,
            //        },
            //        {id:"t_5", text:"Task #2", start_date:"11-04-2020", duration:8,
            //        parent:"t_3"}
            //      ]
            // };
            //   gantt.open("p_1");
            //   //gantt.init("gantt_here");
            //     gantt.parse(data);  
            //   gantt.hasChild("p_1"); //-> true  
            //   gantt.hasChild("t_1"); //-> false             
        })

        gantt.attachEvent("onLightboxSave", function(id, task, is_new){
            console.log('task ',task);
            console.log(is_new);
            // var endDate = task.end_date;
            // endDate = gantt.date.date_part(endDate);
            // task.end_date  = endDate;

            // var startDate = task.start_date; 
            // startDate = gantt.date.date_part(startDate);
            // task.start_date = startDate;

            if(task.text == ''){
                gantt.message({type:"error", text:"Please fill Decripetion field"});
                return false;
            }
            else if(task.status == ''){
                gantt.message({type:"error", text:"Please fill status field"});
                return false;
            }
            else if(task.priority == ''){
                gantt.message({type:"error", text:"Please fill priority field"});
                return false;
            }
            else if(task.owner == ''){
                gantt.message({type:"error", text:"Please fill owner field"});
                return false;
            }
            return true;
        })

        gantt.createDataProcessor({
            task: {
                create: function(data) {
                    
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
                        OwnerId : data.owner,
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
                    var startDate = data.start_date;
                    //startDate =  startDate.split('T')[0];
                    var date =  data.end_date; //.split('T')[0];
                    
                    var fields = {
                        Id: id,
                        Subject : data.text,
                        Start_Date__c : startDate,
                        Duration__c : data.duration,
                        ActivityDate : date,
                        Priority : data.priority,
                        Status : data.Status,
                        OwnerId : data.ownerId,
                        Sprint__c : data.sprint
                    }
                    console.log('task in update ', fields);
                    return upsertTask({task :fields}).then(result => {
                        console.log('updated result ',result);
                    });
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
}