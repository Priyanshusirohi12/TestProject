({
    loadValues : function (cmp) {
        var record = cmp.get("v.record");
        var subheading = '';
        var subHeadingFieldsAPI = cmp.get('v.subHeadingFieldsAPI');
        cmp.get("v.subHeadingFieldsAPI").forEach(function(el){

            if(el.includes('Address') && record[el]) {

                var addressString = '';

                if (record[el]['street']) {
                    addressString += record[el]['street'] + ' ';
                }
                if (record[el]['city']) {
                    addressString += record[el]['city'] + ' ';
                }
                if (record[el]['stateCode']) {
                    addressString += record[el]['stateCode'] + ' ';
                }
                if (record[el]['postalCode']) {
                    addressString += record[el]['postalCode'] + ' ';
                }
                if (record[el]['countryCode']) {
                    addressString += record[el]['countryCode'] + ' ';
                }
                if (addressString) {
                    subheading += addressString + ' • ';
                }

            } else if (el === 'RecordTypeId') {
                // Do not add RecordTypeId to subheading
            } else if (record[el]){
                subheading += record[el] + ' • ';
            }
        });


        subheading = subheading.substring(0,subheading.lastIndexOf('•'));
        cmp.set("v.subHeadingFieldValues", subheading);
    },

    choose : function (cmp,event) {
        var chooseEvent = cmp.getEvent("lookupChoose");
        chooseEvent.setParams({
            "recordId" : cmp.get("v.record").Id,
            "recordLabel":cmp.get("v.record").Name,
            "objectAPIName" : cmp.get('v.objectAPIName'),
            "itemIndex" : cmp.get('v.itemIndex')
        });

        chooseEvent.fire();
    }
})