/**
 * Created on 12/23/17.
 */
({
    handleClick: function (cmp, event, helper) {
        var radio = cmp.find('checkboxButtonInput');
        radio.set('v.checked', !radio.get('v.checked'));
        var appEvent = $A.get("e.c:tc_checkboxTileGroupChange_evt");
        appEvent.fire();
    },

    handleOnchange: function (cmp, event, helper) {
        var appEvent = $A.get("e.c:tc_checkboxTileGroupChange_evt");
        appEvent.fire();
    },
})