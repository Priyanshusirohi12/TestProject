/**
 * Created on 2018-11-21.
 */
({
    doInit : function(cmp, event, helper) {
        cmp.set('v.guarantor.MailingCountryCode', 'US');
    },

    validateData: function (cmp, event, helper) {
        var allValid = cmp.find('requiredField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);


        return allValid;
    },

    onDobChange: function (cmp, event) {
        var curVal = event.getSource().get('v.value');
        var val = curVal.replace(/\D/g, '');
        var newVal = '';
        var sizes = [2, 2, 4];
       // console.log(val.length === 8);
        for (var i in sizes) {


            if (val.length > sizes[i]) {

                //check dates
                // if (i==0 && (parseInt(val) > 12 || parseInt(val) < 1)) {
                //     val = 01;
                // }

                newVal += val.substr(0, sizes[i]) + '/';
                val = val.substr(sizes[i]);
            }
        }

        if (val.length === 8) {
            var d = new Date(newVal);
           // console.log(isNaN(d));
            if (isNaN(d)) {
                val = '';
                newVal = '';
            }
        }

        newVal += val;
        event.getSource().set('v.value', newVal);
    },

    onSSNChange: function (cmp, event) {
        // console.log(event.getSource().get('v.value'));
         var curVal = event.getSource().get('v.value');
         var val = curVal.replace(/\D/g, '');
         var newVal = '';
         var sizes = [3, 2, 4];

         for (var i in sizes) {
             if (val.length > sizes[i]) {
                 newVal += val.substr(0, sizes[i]) + '-';
                 val = val.substr(sizes[i]);
             } else
                 break;
         }

         newVal += val;
         event.getSource().set('v.value', newVal);
    },

    onPhoneChange: function (cmp, event) {
        // console.log(event.getSource().get('v.value'));
         var curVal = event.getSource().get('v.value');
         var val = curVal.replace(/\D/g, '');
         var newVal = '';
         var sizes = [3, 3, 4];

         for (var i in sizes) {
             if (val.length > sizes[i]) {
                 newVal += val.substr(0, sizes[i]) + '-';
                 val = val.substr(sizes[i]);
             } else
                 break;
         }

         newVal += val;
         event.getSource().set('v.value', newVal);
    },

     onPgStateChange: function (cmp, event) {

         cmp.set('v.guarantor.MailingStateCode', cmp.get('v.tempPgState'));
         var pgStateBoolean = cmp.get('v.pgBoolean');
         cmp.set('v.pgBoolean', !pgStateBoolean);

     }
})