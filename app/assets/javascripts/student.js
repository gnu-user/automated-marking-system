// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
    $("#upload_assignment_input").fileupload({dataType: "txt"});

    $("#test_assignment").click(function (event) {
        alert("Test clicked, Try me again!");
    });

    $("#submit_assigment").click(function (event) {
        alert("Submit clicked, Harassment!");
    });
});