var gradientChartOptionsConfigurationWithTooltipPurple = {
  maintainAspectRatio: false,
  responsive: true,
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
  scales: {
    yAxes: [{
      barPercentage: 1.6,
      gridLines: {
        drawBorder: false,
        color: 'rgba(29,140,248,0.0)',
        zeroLineColor: "transparent",
      },
      ticks: {
        callback: function (label, index, labels) {
          return (Math.round(label * 100) / 100).toFixed(2);
        },
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
        autoSkip: true, 
        maxTicksLimit: 24,
        fontColor: "#9a9a9a",
        maxRotation: 0
      }
    }]
  }
};


var elem = document.getElementById("indexChart");
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
      pointHoverBackgroundColor: '#fffb96',
      pointBorderWidth: 20,
      pointHoverRadius: 4,
      pointHoverBorderWidth: 15,
      pointRadius: 0,
      pointHitRadius: 10, 
      data: values,
    }]
  };

  var indexChart = new Chart(ctx, {
    type: 'line',
    data: data,
    options: gradientChartOptionsConfigurationWithTooltipPurple
  });


  $("#0").click(function () {
    // Get the data from the DOM.
    var labels = JSON.parse(document.getElementById("electricity").dataset.labels);
    var values = JSON.parse(document.getElementById("electricity").dataset.values);

    var fieldNameElement = document.getElementById('chart-label');
    fieldNameElement.innerHTML = 'Electricity';
    var data = indexChart.config.data;

    var gradientStroke = ctx.createLinearGradient(0, 230, 0, 50);
    gradientStroke.addColorStop(1, 'RGBA(255, 251, 150, 0.05)');
    gradientStroke.addColorStop(0.9, 'RGBA(255, 251, 150, 0.01)');
    gradientStroke.addColorStop(0.6, 'RGBA(255, 251, 150, 0.001)');
    gradientStroke.addColorStop(0, 'rgba(0,0,0,0)'); //purple colors
    data.datasets[0].backgroundColor = gradientStroke;

    data.datasets[0].borderColor = "#fffb96";
    data.datasets[0].pointBackgroundColor = "#fffb96";
    data.datasets[0].pointHoverBackgroundColor = "#fffb96";
    data.datasets[0].data = values;
    data.labels = labels;
    indexChart.update();
  });
  $("#1").click(function () {
    // Get the data from the DOM.
    var labels = JSON.parse(document.getElementById("solar").dataset.labels);
    var values = JSON.parse(document.getElementById("solar").dataset.values);
    var fieldNameElement = document.getElementById('chart-label');
    fieldNameElement.innerHTML = 'Solar';

    var chart_data = [187, 127, 169, 17, 88, 06, 73, 31, 138, 37, 173, 130, 193, 111, 173, 66, 200, 74, 37, 109, 61, 196, 06, 164];
    var data = indexChart.config.data;

    var gradientStroke = ctx.createLinearGradient(0, 230, 0, 50);
    gradientStroke.addColorStop(1, 'RGBA(5, 255, 161, 0.05)');
    gradientStroke.addColorStop(0.9, 'RGBA(5, 255, 161, 0.01)');
    gradientStroke.addColorStop(0.6, 'RGBA(5, 255, 161, 0.001)');
    gradientStroke.addColorStop(0, 'rgba(0,0,0,0)'); //purple colors
    data.datasets[0].backgroundColor = gradientStroke;

    data.datasets[0].borderColor = "#05ffa1";
    data.datasets[0].pointBackgroundColor = "#05ffa1";
    data.datasets[0].pointHoverBackgroundColor = "#05ffa1";
    data.datasets[0].data = values;
    data.labels = labels;
    indexChart.update();
  });

  $("#2").click(function () {
    // Get the data from the DOM.
    var labels = JSON.parse(document.getElementById("gas").dataset.labels);
    var values = JSON.parse(document.getElementById("gas").dataset.values);
    var fieldNameElement = document.getElementById('chart-label');
    fieldNameElement.innerHTML = 'Gas';
    var data = indexChart.config.data;
    // indexChart.config.borderColor = "#ffffff";
    var gradientStroke = ctx.createLinearGradient(0, 230, 0, 50);

    gradientStroke.addColorStop(1, 'RGBA(255, 113, 206, 0.05)');
    gradientStroke.addColorStop(0.9, 'RGBA(255, 113, 206, 0.01)');
    gradientStroke.addColorStop(0.6, 'RGBA(255, 113, 206, 0.001)');
    gradientStroke.addColorStop(0, 'rgba(0,0,0,0)'); //purple colors
    data.datasets[0].backgroundColor = gradientStroke;
    data.datasets[0].borderColor = "#ff71ce";
    data.datasets[0].pointBackgroundColor = "#ff71ce";
    data.datasets[0].pointHoverBackgroundColor = "#ff71ce";
    data.datasets[0].data = values;
    data.labels = labels;
    indexChart.update();
  });
}