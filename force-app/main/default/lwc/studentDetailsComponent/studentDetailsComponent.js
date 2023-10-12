import { LightningElement } from 'lwc';
   
export default class StudentDetailsComponent extends LightningElement {
    studentDetails=[
        {
            "Id" : 101,
            "Name" : "Priyanshu",
            "Email" : "Priyanshu@gmail.com",
            "DOB" : "18-07-1998"
        },
        {
            "Id" : 102,
            "Name" : "Frdin",
            "Email" : "Fardin@gmail.com",
            "DOB" : "1-05-2000"
        },
        {
            "Id" : 103,
            "Name" : "Pradeep",
            "Email" : "Pradeep",
            "DOB" : "07-01-1998"
        }
    ];
}