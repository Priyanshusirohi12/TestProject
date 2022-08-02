/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-09-04
 * Description: 
 */
({
    onChange : function(cmp, event) {
            console.log('inside onChange');
            var checked = event.getSource().get("v.value");
            var objs = cmp.get("v.objList");
            var objsSelect = cmp.get('v.selectedObj');
            console.log('>>>> objs: ', rels);
            var obj = cmp.get("v.obj");
            console.log('>>>> obj: ', obj);

            if(checked) {

                var len = objsSelect.push(rel);

            } else {
                console.log('inside else');

                if(tempIds != null) {
                    for(var i = 0; i < objs.length; i++) {
                        if(objs[i] == rel) {
                            objsSelect.splice(i,1);
                        }
                    }
                }
            }

            cmp.set("v.selectedObj",objsSelect);
            console.log('objs after set: ', cmp.get('v.selectedObj'));
        }

})