({
	grabWrapper : function(cmp, event, helper) {
 
		var action = cmp.get('c.grabDocWrapper');
        action.setParams({
            recordId: cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(result) {
            if (result.getState() === "SUCCESS") {
                var returnedValue = result.getReturnValue();
                cmp.set('v.wrapper', returnedValue);
                this.formatPhoneNumbers(cmp);
            } else {
                var error = result.getError();
                if (error && Array.isArray(error) && error.length > 0) {
                    var errorData = JSON.parse(error[0].message).message;
                    alert('ERROR: ' + errorData + ' Document Request Form cannot be generated.');
                }           
            }
        });
        
        $A.enqueueAction(action);
	},

	formatPhoneNumbers : function (cmp) {

        var primaryContactPhone = cmp.get('v.wrapper.account.Primary_Contact__r.Phone');
        if (primaryContactPhone != null) {
            var s2 = (""+primaryContactPhone).replace(/\D/g, '');
            if (s2.length == 10) {
                var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
                var formattedPhone = (!m) ? null : m[1] + "-" + m[2] + "-" + m[3];
                cmp.set('v.wrapper.account.Primary_Contact__r.Phone', formattedPhone);
            }
        }

        var equipVendorList = cmp.get('v.wrapper.opportunity.Opportunity_Assets__r');
        if (equipVendorList != null) {
            equipVendorList.forEach(function(item, index) {
                if (item.Vendor__r != null && item.Vendor__r.Phone != null) {
                    var phone = item.Vendor__r.Phone;
                    var s2 = (""+phone).replace(/\D/g, '');
                    if (s2.length == 10) {
                        var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
                        var formattedPhone = (!m) ? null : m[1] + "-" + m[2] + "-" + m[3];
                        item.Vendor__r.Phone = formattedPhone;
                    }
                }
            });
            cmp.set('v.wrapper.opportunity.Opportunity_Assets__r', equipVendorList);
        }

    },
})