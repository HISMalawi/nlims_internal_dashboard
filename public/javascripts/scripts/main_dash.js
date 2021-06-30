$(document).ready(function() {
    ajaxCallAllLabs();
    setInterval(function() {
        ajaxCallAllLabs();
    }, 210000);
});

function setAllLabsData(data) {
    for (const [key, value] of Object.entries(data)) {
        let elementSelector = `${key}`.split('_').join('-');
        $(`#${elementSelector}`).text(value);
        $(`.${elementSelector}`).text(value);

    }
}


function ajaxCallAllLabs() {
    jQuery.ajax({
        url: "query_lab_stats_all_labs",
        type: "GET",
        dataType: "json",
        success: function(data) {
            setAllLabsData(data);
        },
        error: function(err) {
            console.log(err);
        }
    })
}