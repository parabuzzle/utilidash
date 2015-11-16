$(function(){


var chart = $('#currentWattsChart')
   .epoch({
        type: 'time.area',
        data: [ {label: "Current Watt Production", values: [{time: (new Date().getTime() / 1000), y:0}]} ],
        axes: ['left', 'bottom', 'right']
    });

    window.setInterval(function() {
        $.get( "/production.json", function( d ) {
            var dataToPush = [{
                time: (new Date().getTime() / 1000),
                y: d.wattsNow
            }];
            chart.push(dataToPush);
            $('#watts').text('Current Watts being produced: ' + d.wattsNow)
        }, "json" );
    }, 1000);

});
