/**
 * Created by Виталий on 13.10.2016.
 */

$(function() {
    var sum = [],
        y_sum = [],
        $rows = $('.stats__body tr'),
        data = [];

    for (i = 0; i < $rows.first().find('.js-count').length; i++) {
        y_sum[i] = 0;
    }

    $rows.each(function(y) {
        var $this = $(this),
            $elems = $this.find('.js-count'),
            x_sum = 0,
            items = {};
        sum[y] = [];

        $elems.each(function(x) {
            var value = parseInt($(this).text());

            if ( ! isNaN(value)) {
                sum[y][x] = value;
                x_sum += sum[y][x];
                y_sum[x] += sum[y][x];
                items[$('.stats__head .js-event').eq(x).text()] = sum[y][x];
            }
        });

        data.push({
            items: items,
            name: $this.find('.js-user').text()
        });

        $this.find('.js-res-x').text(x_sum);
    });

    var total = 0;

    $('.stats__foot .js-res-y').each(function(i) {
        if (typeof y_sum[i] != 'undefined') {
            $(this).text(y_sum[i]);
            total += y_sum[i];
        }
    });

    $('.js-total').text(total);

    $.ajax({
        url: '/url',
        type: 'POST',
        data: {json: JSON.stringify(data)},
        dataType: "JSON",
        success: function(r) {
            // ok
        }
    });
});