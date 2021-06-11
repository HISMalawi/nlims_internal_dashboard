var hospital
var period;

// ajax call function
function ajaxCall(uri, color) {
    let selector = uri.replace("/query_lab_stats_", "").trim().split('?')[0].split('_').join('-');
    jQuery.ajax({
        url: uri,
        type: "Post",
        success: function(res) {
            $(`#${selector}`).text(res);
            $(`#${selector}`).css('color', `${color}`);
        },
        error: function(err) {
            console.log(err);
        }
    })
}

// search filter sites
function searchFilter() {
    var options = {
        valueNames: ['name']
    };
    var userList = new List('sites', options);

}

// date filter function
function filterByDate() {
    $("form").submit(function(e) {
        e.preventDefault();
        lab = url.split('?')[1].split('&')[0].split('=')[1];
        loadData(lab);
        $('#date').val('');
    });

}


// get and set date
function getSetDate() {
    period = $('#date').val()
    if (period == "") {
        period = "false";
        let d = new Date()
        $('#timeline').text(d.toDateString());
    } else {
        let d = new Date(period)
        $('#timeline').text(d.toDateString());
    }
}

// set hospital
function setHospital(lab) {
    hospital = $(`#${lab}`).text();
    $('#lab').text(hospital);
}


function loadData(lab) {
    parameters = `lab_name=${lab}&period=${period}`
        // Set hospital name
    setHospital(lab);

    // Get filter date
    getSetDate();

    // css style for header and filter
    $('.header').css('display', '');
    $('.filter').css('display', '');

    // total orders ajax call
    url = `/query_lab_stats_total_orders_submitted?${parameters}`;
    ajaxCall(url, 'black');

    // total orders accepted ajax call
    url = `/query_lab_stats_total_orders_accepted?${parameters}`;
    ajaxCall(url, 'green');

    // total orders rejected ajax call
    url = `/query_lab_stats_total_orders_rejected?${parameters}`;
    ajaxCall(url, 'red');

    // total tests ajax call
    url = `/query_lab_stats_total_tests?${parameters}`;
    ajaxCall(url, 'black');

    // total tests verrified ajax call
    url = `/query_lab_stats_total_tests_verrified?${parameters}`;
    ajaxCall(url, 'green');

    // total tests with results ajax call
    url = `/query_lab_stats_total_tests_with_results?${parameters}`;
    ajaxCall(url, '#2a5e52');

    // total tests waiting results
    url = `/query_lab_stats_total_tests_waiting_results?${parameters}`;
    ajaxCall(url, '#f28a52');

    // total tests reject ajax call
    url = `/query_lab_stats_total_tests_rejected?${parameters}`;
    ajaxCall(url, 'red');

    // total tests to be started
    url = `/query_lab_stats_total_tests_to_be_started?${parameters}`;
    ajaxCall(url, '#99a364');

    // last sync ajax call
    url = `/query_lab_stats_last_sync?${parameters}`;
    ajaxCall(url, '#99a364');
}

searchFilter();
filterByDate();