({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
                {label: 'Title', fieldName: 'Name', type: 'text'}
            	, {label: 'Size', fieldName: 'Size_MB__c', type: 'text'}
                , {label: 'Download Link', fieldName: 'URL__c', type: 'url'}
            ]);
		helper.queryFiles (cmp);
	},
    openMultipleFiles: function(cmp, event, helper) {
        /*$A.get('e.lightning:openFiles').fire({
            //recordIds: component.get("v.allContentDocumentIds"),06A41000009WhSEEA0
            //selectedRecordId: component.get("v.currentContentDocumentId")
            recordIds: ['06941000006yzRMAAY'],
            selectedRecordId: '06941000006yzRMAAY'
        });*/
	}
})