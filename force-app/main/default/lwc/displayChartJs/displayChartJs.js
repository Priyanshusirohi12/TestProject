import { LightningElement, api, wire, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import Chart from '@salesforce/resourceUrl/Chart';
import JSPdf from '@salesforce/resourceUrl/JSPdf';
import HTMLCanvas from '@salesforce/resourceUrl/HTMLCanvas';
import RGBColor from '@salesforce/resourceUrl/RGBColor';
import CanvgJS from '@salesforce/resourceUrl/CanvgJS';
import JqueryminJS from '@salesforce/resourceUrl/JqueryminJS';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadByStatus from '@salesforce/apex/LeadGraphController.getLeadByStatus';
import sendEmail from '@salesforce/apex/LeadGraphController.sendEmail';
export default class DisplayChartJs extends LightningElement {
    @track dataSet;
    // @wire(getLeadByStatus)wiredLeads(result){
    //     // if(result.data){
    //     //     this.dataSet = result.data; 
    //     //     console.log('result ',result.data);
    //     //     //this.Initializechartjs();
    //     // } else if (result.error){

    //     // }
    // }



    @api chartjsInitialized = false;
    renderedCallback() {
        if (this.chartjsInitialized) {
          return;
         }
        this.chartjsInitialized = true;

        Promise.all([
              loadScript(this, Chart),
               loadScript(this,JqueryminJS),
              loadScript(this, HTMLCanvas),
               loadScript(this, RGBColor),

        ])
    .then(() => {
        console.log('hth');
        alert('Files loaded.');
        getLeadByStatus().then(result=>{
            
                this.dataSet = result; 
                console.log('result ',result);
                this.Initializechartjs();
             
        })
        
        //this.Initializechartjs();
    })
    .catch(error => {
        console.log('error ',error);
    });

    Promise.all([
        loadScript(this, JSPdf),
         loadScript(this, CanvgJS)

    ]).then(() => {
        console.log('hth2');
        alert('Files loaded.');
        //this.Initializechartjs();
    })
    .catch(error => {
        console.log('error ',error);
    });

   }

   Initializechartjs() {
        console.log("loaded");
        var piechart
        var ctx = this.template.querySelector(".chart")

        piechart = new Chart(ctx ,{
            type: 'pie',
            data: {
                labels: Object.keys(this.dataSet),
                datasets: [
                    {
                        label:'count',
                        data: Object.values(this.dataSet),
                        backgroundColor: ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001f3f", "#39CCCC", "#01FF70", "#85144b", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]

                    }
                ]
            }
        });
    }

    //To generate a blob body of Div into a pdf using JSPdf library.
    printPdf() {
        var targetElem = ''
        console.log('coming in ',targetElem)
        var nodesToRecover = []
         targetElem = this.template.querySelector(".printPdf"); // Select the element which needs to printed in pdf format
        var nodesToRemove = []
        console.log('coming in2 ',targetElem)
        var svgs = $(targetElem).find('svg');
        console.log('svgs ', svgs);
        svgs.each(function(index, node) {
            var parentNode = node.parentNode
            var svg = parentNode.innerHTML
            var canvas = document.createElement('canvas')
            xml = (new XMLSerializer()).serializeToString(node)
            xml = xml.replace(/xmlns=\"http:\/\/www\.w3\.org\/2000\/svg\"/, '')
            canvg(canvas, xml); // html to image
            nodesToRecover.push({
                parent: parentNode,
                child: node
             })
            parentNode.removeChild(node)
            nodesToRemove.push({
            parent: parentNode,
                child: canvas
             })
            parentNode.appendChild(canvas)
        })
        html2canvas(targetElem, {
            onrendered: function(canvas) {
            canvas.style.visibility = 'hidden'
            document.body.appendChild(canvas);
            var doc = new jsPDF('p', 'pt', [canvas.height,canvas.width]); // create pdf file
            doc.addHTML(canvas, {}, function() { // add image to pdf file
                 
                console.log('hye ', btoa(doc.output()));
                //console.log(doc.ouptut());
                //this.downloadChart(' gantt chart', btoa(doc.output()));

            //    sendEmail({pdfBody: btoa(doc.output())})
            //         .then(result => {

            //         })
            //         .catch(error => {
            //             console.log(error);
            //         });
                     document.body.removeChild(canvas)

                })

            }
            
        })
        this.downloadChart(' gantt chart', btoa(doc.output()));
    }
    downloadChart(pdfName, byte){
        var blob = new Blob([byte],{type : "application/pdf"});
        var link = document.createElement("a");
        link.href = window.URL.createObjectURL(blob);
        var fileName = pdfName;
        link.download = fileName;
        link.click(); 
    }

}