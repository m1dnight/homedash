// Chart for electricity
var gradientChartOptionsConfigurationWithTooltipPurple = {
    layout: {
        padding: 0
    },
    maintainAspectRatio: false,
    animation: {
        duration: 0
    },
    legend: {
        display: false
    },
    elements: {
        line: {
            fill: true,
            backgroundColor: "yellow"
        }
    },
    tooltips: {
        backgroundColor: '#FFFFFF',
        titleFontColor: '#FFFFFF',
        bodyFontColor: 'black',
        bodySpacing: 0,
        xPadding: 0,
        mode: "nearest",
        intersect: 0,
        position: "nearest"
    },
    responsive: true,
    scales: {
        yAxes: [{
            barPercentage: 1.6,
            gridLines: {
                drawBorder: true,
                color: 'transparent',
                zeroLineColor: "transparent",
            },
            ticks: {
                padding: -5,
                fontColor: "black",
                display: true,
                autoSkip: true,
                maxTicksLimit: 3
            }
        }],

        xAxes: [{
            barPercentage: 1.6,
            gridLines: {
                drawBorder: true,
                color: "white",
                zeroLineColor: "black",
            },
            ticks: {
                padding: 0,
                fontColor: "black",
                display: true,
                autoSkip: true,
                maxTicksLimit: 3
            }
        }]
    }
};

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

var elem = document.getElementById("solarChart");
if (elem != null) {

    // Get the data from the DOM.
    var labels = JSON.parse(document.getElementById("solar").dataset.labels);
    var values = JSON.parse(document.getElementById("solar").dataset.values);

    var ctx = elem.getContext("2d");


    var data = {
        labels: labels,
        datasets: [{
            label: "kWh",
            borderColor: 'yellow',
            borderWidth: 2,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: 'black',
            pointRadius: 0,
            data: values,
        }]
    };

    var myChart = new Chart(ctx, {
        type: 'line',
        data: data,
        options: gradientChartOptionsConfigurationWithTooltipPurple
    });
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

var elem = document.getElementById("gasChart");
if (elem != null) {

    // Get the data from the DOM.
    var labels = JSON.parse(document.getElementById("gas").dataset.labels);
    var values = JSON.parse(document.getElementById("gas").dataset.values);

    var ctx = elem.getContext("2d");


    var data = {
        labels: labels,
        datasets: [{
            label: "kWh",
            borderColor: 'yellow',
            borderWidth: 2,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: 'black',
            pointRadius: 0,
            data: values,
        }]
    };

    var myChart = new Chart(ctx, {
        type: 'line',
        data: data,
        options: gradientChartOptionsConfigurationWithTooltipPurple
    });
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

var elem = document.getElementById("electricityChart");
if (elem != null) {

    // Get the data from the DOM.
    var labels = JSON.parse(document.getElementById("electricity").dataset.labels);
    var values = JSON.parse(document.getElementById("electricity").dataset.values);

    var ctx = elem.getContext("2d");


    var data = {
        labels: labels,
        datasets: [{
            label: "kWh",
            borderColor: 'yellow',
            borderWidth: 2,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: 'black',
            pointRadius: 0,
            data: values,
        }]
    };

    var myChart = new Chart(ctx, {
        type: 'line',
        data: data,
        options: gradientChartOptionsConfigurationWithTooltipPurple
    });
}