({
    doInit : function(cmp, event, helper) {
        console.log ('doInit ... ');

        helper.getPermission(cmp);
        helper.getIcon(cmp);
        helper.getColumns(cmp);
        helper.getRelatedList(cmp);

    },
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
          console.table(row);
          var parentId = cmp.get('v.recordId');
        switch (action.name) {
            case 'delete':

                 var modalBody;
                 $A.createComponent("c:tc_deleteQuote", {'quote': row},

                    function(content, status) {
                        if (status === "SUCCESS") {
                           modalBody = content;
                           cmp.find('overlayLib').showCustomModal({
                               header: "Delete TValue Quote",
                               body: modalBody,
                               showCloseButton: true,
                               closeCallback: function() {
                               }
                           })
                       }
                   });

                break;
            case 'edit':
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/tvalue-quote?parentId=" + parentId + "&recordId="+row.Id
                });
                urlEvent.fire();
                break;
            default:
                break;
        }
    },
    handleNew: function (cmp, event, helper) {
          var parentId = cmp.get('v.recordId');
          var urlEvent = $A.get("e.force:navigateToURL");
          urlEvent.setParams({
              "url": "/tvalue-quote?parentId=" + parentId + "&recordId="
          });
          urlEvent.fire();
    }
})