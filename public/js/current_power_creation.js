$(function(){

var wattsLast = 1
var wattsTemp = 0
var wattsCurrent = 0

var chart = $('#currentWattsChart')
   .epoch({
        type: 'time.line',
        data: [ {label: "Current Watt Production", values: [{time: (new Date().getTime() / 1000), y:0}]} ],
        axes: ['left', 'bottom', 'right'],
        ticks: { time: 30, right: 10, left: 10 },
        windowSize: 500,
        historySize: 500,
        range: [0, 5000]
    });

    window.setInterval(function() {
        $.get( "/production.json", function( d ) {
            var dataToPush = [{
                time: (new Date().getTime() / 1000),
                y: d.wattsNow
            }];
            chart.push(dataToPush);

            wattsCurrent = d.wattsNow
            if (wattsTemp != wattsCurrent) {
                wattsLast = wattsTemp
                wattsTemp = wattsCurrent
            }

            $('#wattsCurrent').text('Current Watts being produced: ' + wattsCurrent)
            $('#wattsLast').text('Previous: ' + wattsLast)
        }, "json" );
    }, 1000);

});
