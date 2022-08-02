/**
 * Created on 1/1/18.
 */
({
    displayPlaces: function (cmp, searchTerm) {
        var that = this;
        var action = cmp.get("c.getAddressAutoComplete");
        action.setParams({
            "input": searchTerm,
            "types": 'address'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = JSON.parse(response.getReturnValue());
                var predictions = options.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    predictions.forEach (function (el) {
                        addresses.push(
                            {
                                value: el.place_id,
                                label: el.description
                            });
                    });

                    cmp.set("v.filteredOptions", addresses);
                    that.openListbox(cmp, searchTerm);
                }
            } else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },


    getPlaceDetails: function (cmp, placeId) {
        var action = cmp.get("c.getGetPlaceInfoById");
        action.setParams({
            "placeId": placeId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var placeDetails = JSON.parse(response.getReturnValue());
                //console.log('placeDetails: ' + JSON.stringify(placeDetails));

                var address = {};

                placeDetails.result.address_components.forEach(function (el) {
                    address[el.types[0]] = {
                        long_name: el.long_name,
                        short_name: el.short_name
                    }
                });

                if (address.country.short_name === 'US') {

                    var streetAddress = '';
                    if (address.street_number) streetAddress += address.street_number.long_name + ' ';
                    if (address.route.long_name) streetAddress += address.route.long_name;
                    cmp.set('v.street', streetAddress);
                    cmp.set('v.city', (address.hasOwnProperty('locality') ? address.locality.short_name : (address.hasOwnProperty('sublocality_level_1') ? address.sublocality_level_1.short_name : '')));
                    cmp.set('v.stateCode', address.administrative_area_level_1.short_name);

                    if (address.postal_code) {
                        cmp.set('v.postalCode', address.postal_code.long_name);
                    } else {
                        cmp.set('v.postalCode', '');
                    }

                    cmp.set('v.searchTerm', address.formatted_address);
                    cmp.set('v.countryCode', address.country.short_name);

                } else if (address.country.short_name === 'CA') {

                    var streetAddress = '';
                    if (address.street_number) streetAddress += address.street_number.long_name + ' ';
                    if (address.route.long_name) streetAddress += address.route.long_name;
                    cmp.set('v.street', streetAddress);
                    cmp.set('v.city', (address.hasOwnProperty('locality') ? address.locality.short_name : (address.hasOwnProperty('sublocality_level_1') ? address.sublocality_level_1.short_name : '')));
                    cmp.set('v.stateCode', address.administrative_area_level_1.short_name);

                    var postalCode = '';
                    if (address.postal_code) {
                        postalCode += address.postal_code.long_name;
                    } else if (address.postal_code_prefix) {
                        postalCode += address.postal_code_prefix.long_name;
                    }
                    cmp.set('v.postalCode', postalCode);

                    cmp.set('v.searchTerm', address.formatted_address);
                    cmp.set('v.countryCode', address.country.short_name);

                } else {

                }

            } else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    openListbox: function (cmp, searchTerm) {
        var searchLookup = cmp.find("searchLookup");

        if (typeof searchTerm === 'undefined' || searchTerm.length < 3) {
            $A.util.addClass(searchLookup, 'slds-combobox-lookup');
            $A.util.removeClass(searchLookup, 'slds-is-open');
            return;
        }

        $A.util.addClass(searchLookup, 'slds-is-open');
        $A.util.removeClass(searchLookup, 'slds-combobox-lookup');
    },

    clearComponentConfig: function (cmp) {
        var searchLookup = cmp.find("searchLookup");
        $A.util.addClass(searchLookup, 'slds-combobox-lookup');

        cmp.set("v.searchTerm", null);
        cmp.set("v.street", null);
        cmp.set("v.city", null);
        cmp.set("v.postalCode", null);
        cmp.set("v.countryCode", null);
        cmp.set("v.stateCode", null);

    },

})