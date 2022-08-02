({

	searchRecords : function (cmp, event, helper) {

        var searchText = cmp.find('searchInput').get('v.value');
        if (searchText) {
            helper.searchSOSLHelper(cmp, searchText);
        } else {
            helper.searchSOQLHelper(cmp);
        }

	},

    //function to hide the list on onblur event.
    hideList :function (component,event,helper) {

        //Using timeout and $A.getCallback() to avoid conflict between LookupChooseEvent and onblur
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    helper.toggleLookupList(component,
                        false,
                        'slds-combobox-lookup',
                        'slds-is-open'
                    );
                }
            }), 200
        );
    },

    handleChooseEvent : function(cmp, event, helper){

        var updatedRecordId = event.getParam('recordId');
        if (cmp.get('v.clearSearchOnSelect')) {
            cmp.set('v.chosenRecordLabel', '');
        } else {
            var updatedRecordLabel =  event.getParam('recordLabel');
            cmp.set('v.chosenRecordLabel', updatedRecordLabel);
        }
        cmp.set('v.chosenRecordId', updatedRecordId);
    }

})