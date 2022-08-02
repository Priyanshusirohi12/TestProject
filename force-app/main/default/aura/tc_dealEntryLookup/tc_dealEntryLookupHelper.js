({
    // Function to toggle the record list drop-down
    toggleLookupList : function (cmp, ariaexpanded, classadd, classremove) {
        $A.util.addClass(cmp.find("lookupdiv"), classadd);
        $A.util.removeClass(cmp.find("lookupdiv"), classremove);
    },

    // Function to call SOSL apex method
	searchSOSLHelper : function (cmp, searchText) {

        // Input length must be greater than 3 (SOSL limitation that text must be greater than 2
		if (searchText && searchText.length > 3) {

		    // Displays the loading icon for search input field
		    cmp.find('searchInput').set('v.isLoading', true);

		    // Server side callout in TC_DealEntryLookUpCtrl
		    var action = cmp.get('c.search');
		    action.setParams({
		        'objectAPIName': cmp.get('v.objectAPIName'),
		        'searchText': searchText,
		        'whereClause': cmp.get('v.filterArray'),
		        'subHeadingFields': cmp.get('v.subHeadingFieldsAPI')
            });

            action.setCallback(this, function(response) {

                var state = response.getState();
                if (cmp.isValid() && state === 'SUCCESS') {

                    var result = [].concat.apply([], JSON.parse(response.getReturnValue()));

                    cmp.set('v.matchingRecords', result);

                    if (response.getReturnValue()  && response.getReturnValue().length > 0) {
                        this.toggleLookupList(cmp, true, 'slds-is-open', 'slds-combobox-lookup');
                        cmp.find('searchInput').set('v.isLoading', false);
                    } else {
                        this.toggleLookupList(cmp, false, 'slds-combobox-lookup', 'slds-is-open');
                    }
                } else if (state === 'ERROR') {
                    console.log('Error in record search');
                }

            });

            $A.enqueueAction(action);

		} else {

		    this.toggleLookupList(cmp, false, 'slds-combobox-lookup', 'slds-is-open');

        }

	},

     //function to call SOQL apex method.
     searchSOQLHelper : function (cmp) {

         cmp.find("searchInput").set("v.isLoading", true);
         //var searchText = cmp.find("searchinput").get("v.value");

         var action = cmp.get("c.getRecentlyViewed");
         action.setParams({
             "objectAPIName": cmp.get("v.objectAPIName"),
             "whereClause" : cmp.get("v.filterArray"),
             "subHeadingFields":cmp.get("v.subHeadingFieldsAPI")
         });

         // Configure response handler
         action.setCallback(this, function(response) {
             var state = response.getState();
             if(cmp.isValid() && state === "SUCCESS") {
                 if(response.getReturnValue()){
                     cmp.set("v.matchingRecords", response.getReturnValue());
                     if(response.getReturnValue().length>0){
                         this.toggleLookupList(cmp,
                             true,
                             'slds-is-open',
                             'slds-combobox-lookup');
                     }
                     cmp.find("searchInput").set("v.isLoading", false);
                 }
             } else {
                 console.log('Error in loadRecentlyViewed: ' + response.getError()[0].message);
             }
         });
         $A.enqueueAction(action);
     }
})