// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {

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