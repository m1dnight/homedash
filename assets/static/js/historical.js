// Chart for electricity
var gradientChartOptionsConfigurationWithTooltipPurple = {
    maintainAspectRatio: false,
    legend: {
        display: false
    },

    tooltips: {
        backgroundColor: '#f5f5f5',
        titleFontColor: '#333',
        bodyFontColor: '#666',
        bodySpacing: 4,
        xPadding: 12,
        mode: "nearest",
        intersect: 0,
        position: "nearest"
    },
    responsive: true,
    scales: {
        yAxes: [{
            barPercentage: 1.6,
            gridLines: {
                drawBorder: false,
                color: 'rgba(29,140,248,0.0)',
                zeroLineColor: "transparent",
            },
            ticks: {
                padding: 20,
                fontColor: "#9a9a9a"
            }
        }],

        xAxes: [{
            barPercentage: 1.6,
            gridLines: {
                drawBorder: false,
                color: 'rgba(225,78,202,0.1)',
                zeroLineColor: "transparent",
            },
            ticks: {
                padding: 20,
                fontColor: "#9a9a9a"
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
    var gradientStroke = ctx.createLinearGradient(0, 230, 0, 50);

    gradientStroke.addColorStop(1, 'RGBA(5, 255, 161, 0.05)');
    gradientStroke.addColorStop(0.9, 'RGBA(5, 255, 161, 0.01)');
    gradientStroke.addColorStop(0.6, 'RGBA(5, 255, 161, 0.001)');
    gradientStroke.addColorStop(0, 'rgba(0,0,0,0)'); //purple colors

    var data = {
        labels: labels,
        datasets: [{
            label: "kWh",
            fill: true,
            backgroundColor: gradientStroke,
            borderColor: '#05ffa1',
            borderWidth: 2,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: '#05ffa1',
            pointBorderColor: 'rgba(255,255,255,0)',
            pointHoverBackgroundColor: '#d048b6',
            pointBorderWidth: 20,
            pointHoverRadius: 4,
            pointHoverBorderWidth: 15,
            pointRadius: 0,
            data:values,
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
    var gradientStroke = ctx.createLinearGradient(0, 230, 0, 50);

    gradientStroke.addColorStop(1, 'RGBA(255, 251, 150, 0.05)');
    gradientStroke.addColorStop(0.9, 'RGBA(255, 251, 150, 0.01)');
    gradientStroke.addColorStop(0.6, 'RGBA(255, 251, 150, 0.001)');
    gradientStroke.addColorStop(0, 'rgba(0,0,0,0)'); //purple colors

    var data = {
        labels: labels,
        datasets: [{
            label: "kWh",
            fill: true,
            backgroundColor: gradientStroke,
            borderColor: '#fffb96',
            borderWidth: 2,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: '#fffb96',
            pointBorderColor: 'rgba(255,255,255,0)',
            pointHoverBackgroundColor: '#d048b6',
            pointBorderWidth: 20,
            pointHoverRadius: 4,
            pointHoverBorderWidth: 15,
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
    var gradientStroke = ctx.createLinearGradient(0, 230, 0, 50);

    gradientStroke.addColorStop(1, 'RGBA(255, 113, 206, 0.05)');
    gradientStroke.addColorStop(0.9, 'RGBA(255, 113, 206, 0.01)');
    gradientStroke.addColorStop(0.6, 'RGBA(255, 113, 206, 0.001)');
    gradientStroke.addColorStop(0, 'rgba(0,0,0,0)'); //purple colors

    var data = {
        labels: labels,
        datasets: [{
            label: "m³",
            fill: true,
            backgroundColor: gradientStroke,
            borderColor: '#ff71ce',
            borderWidth: 2,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: '#d048b6',
            pointBorderColor: 'rgba(255,255,255,0)',
            pointHoverBackgroundColor: '#d048b6',
            pointBorderWidth: 20,
            pointHoverRadius: 4,
            pointHoverBorderWidth: 15,
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