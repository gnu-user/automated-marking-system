/*
 * Automated Marking System (AMS)
 * 
 * A scalable automated marking system that provides automated marking, quality
 * feedback, and cheating detection all in one easy to use solution.
 *
 *
 * Copyright (C) 2014, Joseph Heron, Jonathan Gillett, Daniel Smullen, 
 * and Khalil Fazal
 * All rights reserved.
 *
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
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