var hospital;
var period;
var test_type = "";

$('.today').css('display', 'none');
$('progress').css('display', 'none');

// ajax call function
function ajaxCall(uri, color = 'black') {
    let selector = uri.replace("/query_lab_stats_", "").trim().split('?')[0].split('_').join('-');


    $(`#${selector}`).text('!');
    $('.today').css("display", "none");
    jQuery.ajax({
        url: uri,
        type: "Post",
        dataType: "json",
        success: function(res) {
            $('.test-title').css('display', 'initial');

            if (selector.toString() == "last-sync") {
                let lastSync = new Date(res.data).toISOString();
                console.log(lastSync);
                $(`#${selector}`).text(lastSync);

            } else {
                $(`#${selector}`).text(res.data);
            }

            $(`.${selector}`).text(res.today);
            $('.today').css("display", "initial");
            $(`#${selector}`).css('color', `${color}`);

            var progress_value = parseInt($('progress').attr('value'));
            if (progress_value < 110) {
                progress_value += 10;
                $('progress').attr('value', `${progress_value}`);
            } else {
                $('progress').attr('value', `${progress_value + 10}`);
                $('progress').fadeOut(3000);
            }

            // handle data list for test types
            if (Array.isArray(res)) {
                $('.today').css('display', 'none');
                tests = [...new Set(res)];
                tests.forEach(function(test) {
                    container = $('datalist');
                    container.append(`<option class="tests-options" value="${test}"></option>`) // $('option').attr('value', test)
                })
            }

        },
        error: function(err) {
            console.log(err);
        }
    })
}

// search filter sites
function searchLabs() {
    var options = {
        valueNames: ['name']
    };
    var userList = new List('sites', options);

}

// date filter function
function loadByFilter() {
    $("form").submit(function(e) {
        e.preventDefault();
        lab = url.split('?')[1].split('&')[0].split('=')[1];
        loadData(lab);
        $('#date').val('');
        $('#test-type').val('');
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

function setTestType() {
    test_type = $('#test-type').val();
    test_type = test_type.toString();
    if (test_type.length > 0) {
        $('#ttype').text(test_type);
        $('#test-type-title').css('display', 'initial');
    } else {
        $('#test-type-title').css('display', 'none');
    }
    test_type = test_type.toString().replace('&', 'Aand');
}

// set hospital
function setHospital(lab) {
    hospital = $(`#${lab}`).text();
    $('#lab').text(hospital);
}


function loadData(lab) {
    setHospital(lab);
    setTestType();
    getSetDate();

    let parameters = `lab_name=${lab}&period=${period}&test_type=${test_type}`;
    // css style for header and filter
    $('.header').css('display', '');
    $('.filter').css('display', '');
    $('progress').css('display', 'initial');

    // total orders ajax call

    url = `/query_lab_stats_total_orders_submitted?${parameters}`;
    ajaxCall(url, 'black');

    // total orders accepted ajax call
    url = `/query_lab_stats_total_orders_accepted?${parameters}`;
    ajaxCall(url, 'green');

    url = `/query_lab_stats_total_orders_to_be_accepted?${parameters}`;
    ajaxCall(url, '#99a364');

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

    // total tests to be started
    url = `/query_lab_stats_total_tests_voided_failed?${parameters}`;
    ajaxCall(url, 'red');

    // last sync ajax call
    url = `/query_lab_stats_last_sync?${parameters}`;
    ajaxCall(url, 'black');


    $('progress').attr('value', '0');

}

// data list tests types ajax call
let url = '/query_lab_stats_test_types';
ajaxCall(url);


searchLabs();
loadByFilter();