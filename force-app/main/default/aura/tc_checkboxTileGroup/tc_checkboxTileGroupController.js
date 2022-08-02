/**
 * Created on 12/23/17.
 */
({

    optionsChange : function (cmp) {
        console.log('optionsChange');
        var values = [];
        cmp.get('v.options').forEach(function (el) {
            if (el.isSelected) {
                values.push(el.value);
            }
        });
        cmp.set('v.selectedValues', values);
    }
})