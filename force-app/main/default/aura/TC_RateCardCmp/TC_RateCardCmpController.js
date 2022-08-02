({
    doInit : function(cmp, event, helper) {
        console.log ('doInit ... ');
        
        //allows component to be used directly, or inside a visualforce page
        if(cmp.get("v.rateCardId") == undefined){
        	var recordId = cmp.get("v.recordId")
        	console.log('id = ' + recordId);
        	cmp.set("v.rateCardId", recordId);
        }
        helper.getRows(cmp);
        helper.getColumns(cmp);
    },
    saveRateCard : function(cmp, event, helper) {
        helper.saveChanges (cmp, event, false);
    },    
    saveRateCardAndClose : function(cmp, event, helper) {  
        helper.saveChanges (cmp, event, true);
    },    
    cancelAndClose : function(cmp, event, helper) {
        helper.navigateBackToRateCard (cmp);
    }
    
    
    
    
    
    //modeal test code   
    ,openModal: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModal: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   }
    
    
    
})