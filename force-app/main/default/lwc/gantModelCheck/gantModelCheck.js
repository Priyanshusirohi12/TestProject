import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class GantModelCheck extends LightningElement {
    renderedCallback(){
        this.initializeUI();
        
    }
    initializeUI(){
        var taskId = null;
        unwrap("00B5g000009EzS3EAK");
        gantt.showLightbox = function unwrap(id) {
            taskId = id;
            var task = gantt.getTask(id);
        
            var form = getForm();
            var input = form.querySelector("[name='description']");
            input.focus();
            input.value = task.text;
        
            form.style.display = "block";
        
            form.querySelector("[name='save']").onclick = save;
            form.querySelector("[name='close']").onclick = cancel;
            form.querySelector("[name='delete']").onclick = remove;
        };
        
        gantt.hideLightbox = function(){
            getForm().style.display = "";
            taskId = null;
        }
        
        
        function getForm() {
            return document.getElementById("my-form");
        };
        
        function save() {
            var task = gantt.getTask(taskId);
        
            task.text = getForm().querySelector("[name='description']").value;
        
            if(task.$new){
                delete task.$new;
                gantt.addTask(task,task.parent);
            }else{
                gantt.updateTask(task.id);
            }
        
            gantt.hideLightbox();
        }
        
        function cancel() {
            var task = gantt.getTask(taskId);
        
            if(task.$new)
            gantt.deleteTask(task.id);
            gantt.hideLightbox();
        }
        
        function remove() {
            gantt.deleteTask(taskId);
            gantt.hideLightbox();
        }
    }
}