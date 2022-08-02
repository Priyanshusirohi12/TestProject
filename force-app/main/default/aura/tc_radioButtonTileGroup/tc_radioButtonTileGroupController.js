/**
 * Created on 12/23/17.
 */
({
    handleValueChangeEvent : function (cmp, event, helper) {
        if (cmp.get('v.name') === event.getSource().get('v.name')){
            var value = event.getParam("radioValue");
            cmp.set('v.value', value);
            console.log(cmp.get('v.name') + ' tileGroup_handleValueChangeEvent', value);
        }

    },

    optionsChange : function (cmp) {
        cmp.get('v.options').forEach(function (el) {
            if (el.isSelected) {
                cmp.set('v.value', el.value);
            }
        });
    }
})