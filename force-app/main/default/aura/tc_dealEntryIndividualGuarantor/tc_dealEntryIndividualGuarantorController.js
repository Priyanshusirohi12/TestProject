({
    doInit : function (cmp, event, helper) {
        helper.handleAddressChangeChooseEvent(cmp);
    },

    toggleAdditionalSection : function(cmp, event, helper) {
       helper.additionalSectionHelper(cmp,event);
    },

	handleChooseEvent : function (cmp, event, helper) {
		helper.handleChooseEventHelper(cmp, event);
	},

    onStateChange : function (cmp, event, helper) {
        helper.onStateChangeHelper(cmp);
    },

    updateSelectedPGs : function (cmp, event, helper) {

        var checkbox = cmp.get('v.guarantorWrapper.isSelected');
        if (checkbox) {
            cmp.set('v.isSelectedNum', cmp.get('v.isSelectedNum') + 1);
        } else {
            cmp.set('v.isSelectedNum', cmp.get('v.isSelectedNum') - 1);
        }

    },

    updateSelectedCGs : function (cmp, event, helper) {

        var checkbox = cmp.get('v.guarantorWrapper.isSelected');
        if (checkbox) {
            cmp.set('v.isSelectedNum', cmp.get('v.isSelectedNum') + 1);
        } else {
            cmp.set('v.isSelectedNum', cmp.get('v.isSelectedNum') - 1);
        }

    },

    onSignerCheck : function (cmp, event) {
        cmp.set('v.guarantorWrapper.guarantor.Signer__c', cmp.find('signerCheck').get("v.value"));
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

})