/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-28
 * Description: 
 */
({
    onChange : function(cmp, event) {
        console.log('inside onChange');
        var checked = event.getSource().get("v.value");
        var tempIds = cmp.get("v.templateIds");
        console.log('>>>> templateIds: ', tempIds);
        var tempId = cmp.get("v.templateId");
        console.log('>>>> tempId: ', tempId);

        if(checked) {

            var len = tempIds.push(tempId);

        } else {
            console.log('inside else');

            if(tempIds != null) {
                for(var i = 0; i < tempIds.length; i++) {
                    if(tempIds[i] == tempId) {
                        tempIds.splice(i,1);
                    }
                }
            }
        }

        cmp.set("v.templateIds",tempIds);
        console.log('templateIds after set: ', cmp.get('v.templateIds'));
    }
})