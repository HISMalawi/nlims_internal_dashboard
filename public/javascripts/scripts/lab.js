function loadData(lab) {

    // Set hospital name
    hospital = $(`#${lab}`).text();
    $('#lab').text(hospital);

    // Get filter date
    period = $('#date').val()
    if (period == "") {
        period = "false";
        d = new Date()
        $('#timeline').text(d.toDateString());
    } else {
        d = new Date(period)
        $('#timeline').text(d.toDateString());
    }

    // css style for header and filter
    $('.header').css('display', '');
    $('.filter').css('display', '');

    // total orders ajax call
    url = "/query_lab_stats_total_orders?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-orders-submitted").text(res);
            $("#total-orders-submitted").css('color', 'black');
        },
        error: function(err) {
            console.log(err);
        }
    })

    // total orders accepted ajax call
    url = "/query_lab_stats_total_orders_accepted?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-orders-accepted").text(res);
            $("#total-orders-accepted").css('color', 'green');
        },
        error: function(err) {
            console.log(err);
        }
    })

    // total orders rejected ajax call
    url = "/query_lab_stats_total_orders_rejected?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-orders-rejected").text(res);
            $("#total-orders-rejected").css('color', 'red');
        },
        error: function(err) {
            console.log(err);
        }
    })

    // total tests ajax call
    url = "/query_lab_stats_total_tests?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-tests").text(res);
            $("#total-tests").css('color', 'black');
        },
        error: function(err) {
            console.log(err);
        }
    })

    // total tests verrified ajax call
    url = "/query_lab_stats_total_tests_verrified?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-tests-verrified").text(res);
            $("#total-tests-verrified").css('color', 'green');
        },
        error: function(err) {
            console.log(err);
        }
    })


    // total tests with results ajax call
    url = "/query_lab_stats_total_tests_with_results?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-tests-with-results").text(res);
            $("#total-tests-with-results").css('color', '#2a5e52');
        },
        error: function(err) {
            console.log(err);
        }
    })

    // total tests waiting results
    url = "/query_lab_stats_total_tests_waiting_results?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-tests-waiting-results").text(res);
            $("#total-tests-waiting-results").css('color', '#f28a52');
        },
        error: function(err) {
            console.log(err);
        }
    })

    // total tests reject ajax call
    url = "/query_lab_stats_total_tests_rejected?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-tests-rejected").text(res);
            $("#total-tests-rejected").css('color', 'red');
        },
        error: function(err) {
            console.log(err);
        }
    })

    // total tests to be started
    url = "/query_lab_stats_total_tests_to_be_started?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#total-tests-to-be-started").text(res);
            $("#total-tests-to-be-started").css('color', '#99a364');
        },
        error: function(err) {
            console.log(err);
        }
    })


    // last sync ajax call
    url = "/query_last_sync?lab_name=" + lab + "&period=" + period;
    jQuery.ajax({
        url: url,
        type: "Post",
        success: function(res) {
            $("#last_sync").text(res);
        },
        error: function(err) {
            console.log(err);
        }
    })

}

// date filter logic call
$("form").submit(function(e) {
    e.preventDefault();
    lab = url.split('?')[1].split('&')[0].split('=')[1];
    loadData(lab);
    $('#date').val('');
});

// search filter sites
var options = {
    valueNames: ['name']
};
var userList = new List('sites', options);