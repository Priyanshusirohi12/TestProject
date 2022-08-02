({
	changeOwner : function(cmp, event, helper) {
        cmp.set('v.loaded', !cmp.get('v.loaded'));
		helper.changeOwner(cmp,event,helper);
	},
    userSearch : function(cmp, event, helper) {
        helper.userSearch(cmp, event, helper);
    },
    searchAllUsers : function(cmp, event, helper) {
        helper.searchAllUsers(cmp, event, helper);
    },
    
    cancel : function(cmp, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    doInit : function(cmp, event, helper) {
        helper.getOpportunity(cmp, event, helper);
    }
})