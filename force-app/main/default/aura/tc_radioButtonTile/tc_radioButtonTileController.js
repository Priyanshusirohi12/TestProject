/**
 * Created on 12/23/17.
 */
({
    handleClick: function (cmp, event, helper) {
        var radio = cmp.find('radioButtonInput');
        radio.set('v.checked', true);

        var radioValue = cmp.get('v.value');
        var appEvent = $A.get("e.c:tc_radioButtonTileGroupChange_evt");
        appEvent.setParams({"radioValue":radioValue});
        appEvent.fire();

    },

    handleOnchange: function (cmp, event, helper) {
        event.stopPropagation();
        var radioValue = cmp.get('v.value');
        var appEvent = $A.get("e.c:tc_radioButtonTileGroupChange_evt");
        appEvent.setParams({"radioValue":radioValue});
        appEvent.fire();

    },

    handleApplicationEvent: function (cmp, event, helper) {
        if (cmp.get('v.name') === event.getSource().get('v.name')){ //make sure it's the same group that fired event
            cmp.set('v.isSelected', event.getSource().get('v.value') === cmp.get('v.value'))
        }
    }
})