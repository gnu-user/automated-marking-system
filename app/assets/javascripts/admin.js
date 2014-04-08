// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {

	$("#upload_input").fileupload({dataType: "txt"});

	//TODO set up adding new test cases
	$('#upload_eval').click(function(event) {
		alert("Upload eval clicked, Don't Click Me!");

		// Accept an upload for the test cases to be parsed for evaluation
		return false;
	});

	$('#upload_sample').click(function(event) {
		alert("Upload sample clicked, Don't Click Me!");
		// Accept an upload for the test cases to be parsed for sample
		return false;
	});

	/*$('#create_assignment').click(function(event) {
		alert("Create assignment clicked, Don't Click Me!");
		// TODO update the assignment::released and delete session[:assignment_id]
		return false;
	});*/

	$('#help_yaml').click(function(event) {
		helpYaml();

		return false;
	});

	$('#help_yaml_2').click(function(event) {
		helpYaml();

		return false;
	});
});

function helpYaml() {
	alert("No help for you!");
}