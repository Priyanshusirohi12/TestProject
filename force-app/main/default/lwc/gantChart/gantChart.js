import { LightningElement, track } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import jscharting from '@salesforce/resourceUrl/Chart';
export default class GanttChart extends LightningElement {
    @track chart;
    /*connectedCallback(){
        console.log('connected callback');
    }
    renderedCallback() {
        Promise.all([
            loadScript(this, load )
        ]).then((result) =>{
            console.log('Fiels loaded?');

         google.charts.load('current', {'packages':['gantt']});
         google.charts.setOnLoadCallback(this.drawChart);
         
        }).catch(error => {
            console.log('error  :-  ',error);
        });

        console.log('renderedcallback');
    }


    
    daysToMilliseconds(days) {
        return days * 24 * 60 * 60 * 1000;
    }

    drawChart() {
        let data = new google.visualization.DataTable();
        data.addColumn('string', 'Task ID');
        data.addColumn('string', 'Task Name');
        data.addColumn('date', 'Start Date');
        data.addColumn('date', 'End Date');
        data.addColumn('number', 'Duration');
        data.addColumn('number', 'Percent Complete');
        data.addColumn('string', 'Dependencies');

        data.addRows([
          ['Research', 'Find sources',
          new Date(2015, 0, 1), new Date(2015, 0, 5), null,  100,  null],
          ['Write', 'Write paper',
          null, new Date(2015, 0, 9), this.daysToMilliseconds(3), 25, 'Research,Outline'],
          ['Cite', 'Create bibliography',
          null, new Date(2015, 0, 7), this.daysToMilliseconds(1), 20, 'Research'],
          ['Complete', 'Hand in paper',
          null, new Date(2015, 0, 10), this.daysToMilliseconds(1), 0, 'Cite,Write'],
          ['Outline', 'Outline paper',
          null, new Date(2015, 0, 6), this.daysToMilliseconds(1), 100, 'Research']
        ]);

        let options = {
          height: 275
        };

        let chart = new google.visualization.Gantt(document.getElementById('chart_div'));

         chart.draw(data, options);
       }*/
    renderedCallback() {
        // JS 
        var config = {
            debug: true,
            type: 'horizontal column',
            zAxisScaleType: 'stacked',
            toolbar_items_export_position:
                'inside bottom left',
            title_label_text:
                'Project Beta from %min to %max',
            legend: {
                position: 'inside right top',
                template: '%icon %name'
            },
            yAxis: {
                scale_type: 'time',
                scale_range_padding: 0.15,
                markers: [
                    {
                        value: '4/20/2020',
                        color: 'red',
                        label_text: 'Now'
                    },
                    {
                        value: ['5/12/2020', '6/1/2020'],
                        color: ['orange', 0.5],
                        label_text: 'Vacation'
                    }
                ]
            },
            defaultPoint: {
                tooltip:
                    '<b>%name</b> %low - %high<br/>{days(%high-%low)} days'
            },
            yAxis_scale_type: 'time',
            defaultSeries: {
                firstPoint: {
                    outline: { color: 'darkenMore', width: 2 },
                    xAxisTick_label_text: '<b>%value</b>'
                }
            },
            series: [
                {
                    name: 'Initiate Project',
                    points: [
                        {
                            name: 'Initiate Project',
                            y: ['1/1/2020', '3/15/2020']
                        },
                        {
                            name: 'Project Assignments',
                            y: ['1/1/2020', '1/25/2020']
                        },
                        {
                            name: 'Outlines/Scope',
                            y: ['1/25/2020', '2/15/2020']
                        },
                        {
                            name: 'Business Alignment',
                            y: ['2/15/2020', '3/15/2020']
                        }
                    ]
                },
                {
                    name: 'Plan Project',
                    points: [
                        {
                            name: 'Plan Project',
                            y: ['3/15/2020', '5/20/2020']
                        },
                        {
                            name: 'Determine Process',
                            y: ['3/15/2020', '4/12/2020']
                        },
                        {
                            name: 'Design Layouts',
                            y: ['4/12/2020', '5/8/2020']
                        },
                        {
                            name: 'Design Structure',
                            y: ['5/8/2020', '5/20/2020']
                        }
                    ]
                },
                {
                    name: 'Implement Project',
                    points: [
                        {
                            name: 'Implement Project',
                            y: ['5/20/2020', '7/28/2020']
                        },
                        {
                            name: 'Designs',
                            y: ['5/20/2020', '6/10/2020']
                        },
                        {
                            name: 'Structures',
                            y: ['6/10/2020', '6/15/2020']
                        },
                        {
                            name: 'D&S Integration',
                            y: ['6/15/2020', '7/28/2020']
                        }
                    ]
                }
            ]
        };
        config.series.forEach(function (s) {
            updateComplete(s, '4/20/2020');
        });
        Promise.all([
            loadScript(this, jscharting)
        ]).then(() => {
            console.log('JSC ', JSC.chart);
            this.chart = JSC.Chart('chartDiv', config);
            console.log(this.chart);

        }).catch(error => {
            console.log('error  :-  ', error);
        });


        /** 
         * Will mark the % complete value of points up to the specified date. 
         * @param series Series to update 
         * @param date Date threshold 
         */
        function updateComplete(series, date) {
            var threshold = norm(date);
            series.points.forEach(function (p, i) {
                var pRange = p.y.map(norm);
                if (threshold > pRange[1]) {
                    p.complete = 1;
                } else if (threshold > pRange[0]) {
                    p.complete =
                        (threshold - pRange[0]) /
                        (pRange[1] - pRange[0]);
                }
            });
            function norm(d) {
                return new Date(d).getTime();
            }
        }
    }


}