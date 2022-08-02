/**
 * Created on 1/1/18.
 */
({

    onKeyup: function (cmp, event, helper) {

        var searchTerm = cmp.get("v.searchTerm");

        helper.displayPlaces(cmp, searchTerm);
    },

    selectOption: function (cmp, event, helper) {
        //event.stopPropagation();
        var selectedItem = event.currentTarget.dataset.record;
        var selectedValue = event.currentTarget.dataset.value;

        helper.getPlaceDetails(cmp, selectedValue);
        var searchLookup = cmp.find("searchLookup");
        $A.util.removeClass(searchLookup, 'slds-is-open');

        var iconDirection = cmp.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_left');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_right');

        cmp.set("v.searchTerm", selectedItem);

    },

    clear: function (cmp, event, helper) {

        helper.clearComponentConfig(cmp);
    },

    handleOnBlur: function (cmp, event, helper) {

        window.setTimeout(
            $A.getCallback(function() {
                if (cmp.isValid()) {
                    var searchLookup = cmp.find("searchLookup");
                    $A.util.removeClass(searchLookup, 'slds-is-open');
                }
            }), 500
        );
    }

})