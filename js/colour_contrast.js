function linear_rgb(val) {
    if (val <= 0.03928) {
        return val / 12.92;
    } else {
        return ((val + 0.055)/1.055) ** 2.4;
    }
}

function relative_luminance(rgb_color) {
    return 0.2126 * linear_rgb(rgb_color.r) + 0.7152 * linear_rgb(rgb_color.g) + 0.0722 * linear_rgb(rgb_color.b);
}

// Relative Luminance 3D graph //
var graph3d = null;
var current_fixed_values = null;

var initial_camera = {horizontal: 1.0, vertical: 0.5, distance: 1.7};

function reset_camera() {
    graph3d.setCameraPosition(initial_camera);
}

function xy_to_rbg(x, y) {
    function red_val(x, y) {
        return "red" in current_fixed_values ? current_fixed_values.red : x;
    }
    function green_val(x, y) {
        return "green" in current_fixed_values ? current_fixed_values.green : "red" in current_fixed_values ? x : y;
    }
    function blue_val(x, y) {
        return "blue" in current_fixed_values ? current_fixed_values.blue : y;
    }
    return {r: red_val(x, y), g: green_val(x, y), b: blue_val(x, y)};
}

function rl_set_data(fixed_values) {
    //console.log(fixed_values);
    current_fixed_values = fixed_values;
    var data = new vis.DataSet();
    var steps = 32;
    var inc = 1.0 / (steps - 1);
    for (var x = 0.0; x <= 1.0; x += inc) {
        for (var y = 0.0; y <= 1.0; y += inc) {
            var color = xy_to_rbg(x, y);
            var lum = relative_luminance(color);
            console.log("red: " + color.r + ", green: " + color.g + ", blue: " + color.b + ", lum: " + lum);
            data.add({x:x,y:y,z:lum,style:lum}); 
        }
    }
    graph3d.setData(data);
    graph3d.setOptions({
        xLabel: "red" in current_fixed_values ? "Green" : "Red",
        yLabel: "blue" in current_fixed_values ? "Green" : "Blue",
    });
}

function setup_relative_luminance(elem_id) {
    // specify options
    var options = {
        width:  '500px',
        height: '552px',
        style: 'grid',
        showPerspective: true,
        showGrid: true,
        showShadow: false,
        keepAspectRatio: true,
        verticalRatio: 0.5,
        //tooltip: true,
        tooltip: rl_tooltip,
        zLabel: 'Relative Luminance',
        cameraPosition: initial_camera,
    };

    // Instantiate our graph object.
    var container = document.getElementById(elem_id);
    graph3d = new vis.Graph3d(container);
    rl_set_data({blue: 0});
    graph3d.setOptions(options);
}

function rl_tooltip(point) {
    var color = xy_to_rbg(point.x, point.y);
    function to_hex(val) { 
        var s = Math.round(val * 255).toString(16);
        if (s.length < 2) {
            s = '0' + s;
        }
        return s;
    }
    var color_str = "#" + to_hex(color.r) + to_hex(color.g) + to_hex(color.b);
    return "<table><tbody><tr><td>Red:</td><td>" + 
    color.r.toFixed(2) + "</td></tr><tr><td>Green:</td><td>" + 
    color.g.toFixed(2) + "</td></tr><tr><td>Blue:</td><td>" + 
    color.b.toFixed(2) + "</td></tr><tr><td>Relative Luminance:</td><td>" +
    point.z.toFixed(2) + "</td></tr></tbody></table>" +
    '<div style="height:20px;width:100%;background-color:' + color_str + ';"></div>';
}

function update_fixed(elem_id, color) {
    var value = $("#" + elem_id).val();
    if (!$.isNumeric(value)) {
        console.log("Invalid value");
        return;
    }
    var fixed_values = {};
    fixed_values[color] = parseFloat(value);
    rl_set_data(fixed_values);
}

// linear RGB //

// http://www.chartjs.org/docs/
function setup_linear_rgb(elem_id) {
    var dataset = [];
    var steps = 32;
    var inc = 1.0 / (steps - 1);
    for (var x = 0.0; x <= 1.0; x += inc) {
        dataset.push({x: x, y: linear_rgb(x)});
    }    
    var myLineChart = new Chart(document.getElementById(elem_id), {
        type: 'line',
        data: {
            datasets: [{
                data: dataset,
                label: 'Linear RGB',
                fill: false,
                borderColor: '#2020FF',
                pointRadius: 0, // don't show points
                pointHoverRadius: 0,
            }],
        },
        options: {
            scales: {
                xAxes: [{
                    type: 'linear',
                    position: 'bottom',
                    scaleLabel: {
                        display: true,
                        labelString: 'regular RGB',
                    },
                }],
                yAxes: [{
                    scaleLabel: {
                        display: true,
                        labelString: 'linear RGB',
                    },
                }],
            },
            title: {
                display: true,
                text: 'Conversion of regular RGB to linear RGB',
            },
            legend: {
                display: false,
            },
            tooltips: {
                enabled: false,
            },
            animation: {
                duration: 0,
            },
        }
    });
}
