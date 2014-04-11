##############################################################################
#
# Automated Marking System (AMS)
# 
# A scalable automated marking system that provides automated marking, quality
# feedback, and cheating detection all in one easy to use solution.
#
#
# Copyright (C) 2014, Joseph Heron, Jonathan Gillett, Daniel Smullen, 
# and Khalil Fazal
# All rights reserved.
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
class AdminController < ApplicationController
	# TODO FOR ALL
	# handle Grades link for latest assignments (better define)
	# handle logout

	def index
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		@assignments = ActiveRecord::Base.connection.execute("select assignments.id as id, assignments.name as name, assignments.posted as posted, assignments.due as due, COUNT(submissions.id) as submissions, AVG(grades.final) as final_grade from assignments LEFT OUTER JOIN submissions ON assignments.id = submissions.assignment_id LEFT OUTER JOIN grades ON submissions.id = grades.submission_id GROUP BY assignments.id")

		# TODO handle all the links shown
		# handle view assignment positing (go to latest assignment)
		# handle link to assignment page (for review)
		# handle link to grades for each finished assignment
		@review_submissions = 12
		@view_assignment = 9
		@resolve_issues = 2
	end

	def new
		validate_admin
		latest_assignment
		getHeaderInfo(0)
		# TODO handle form submission and populating the db
		# handle add button
		# handle upload button
		# handle button submit assignment
		@assignment = Assignment.new
	end

	def grading
		validate_admin
		latest_assignment
		getHeaderInfo(1)
		# TODO handle grades page using param[:id]

		#@submissions = Submission.find_all_by_assignment_id(params[:id])

		@grades = ActiveRecord::Base.connection.execute("select students.first_name as firstname, students.last_name as lastname, students.student_id as student_id, assignments.code_weight as code_weight, grades.code as code_grade, assignments.test_case_weight as test_case_weight, grades.testcase as test_case_grade, grades.final as final_grade from students, assignments, submissions, grades where students.id = submissions.student_id and assignments.id = submissions.assignment_id and submissions.id = grades.submission_id and assignments.id = #{params[:id].to_i}")
	end

	def cheat
		validate_admin
		latest_assignment
		getHeaderInfo(2)
		# TODO handle cheating page using param[:id]
	end

	def show
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		@assignment = Assignment.find_by_id(params[:id])

		if @assignment == nil
			#TODO give error message
			#redirect_to "#{root_url}admin", :notice => "No Activity found!"
		end
	end

	def create
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		# TODO check if at least 1 evaluation testcase has been submitted
		@value = params.require(:assignment).permit(:name, :description, :posted, :due, :max_time, :attempts, :code_weight, :test_case_weight)
		#@value[:posted] = 
		@assignment = Assignment.new#(@value)
		@assignment.name = @value[:name]
		@assignment.description = @value[:description]

		@assignment.posted = fixDate(@value[:posted])
		@assignment.due = fixDate(@value[:due])
		@assignment.max_time = @value[:max_time]
		@assignment.attempts = @value[:attempts]
		@assignment.code_weight = @value[:code_weight]
		@assignment.test_case_weight = @value[:test_case_weight]
		@assignment.admin_id = session[:prof_id]
		@assignment.released = false

		if @assignment.save
			#Create the new TestCase Sample and TestCase Eval
			session[:assignment_id] = @assignment.id 
		else
			redirect_to "#{root_url}admin/new"
		end
	end

	def upload
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		@contents = params[:file].read

		if !TestCase.parseYaml(@contents, session[:assignment_id])
			# TODO show an error
			redirect_to "#{root_url}"
		end
	end

	def submit
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		if TestCase.where("assignment_id = #{session[:assignment_id].to_i} AND sample = 't'").count > 0
		else
			# TODO report error
			redirect_to "#{root_url}" 
		end

		# Set the assignment as released so when the posted date passes it will show up for the students
		assignment = Assignment.find_by_id(session[:assignment_id])
		assignment.released = true

		#TODO catch an error if there is one
		assignment.save

	end

	private

	def getHeaderInfo(onGrades)
		#@lastest = ActiveRecord::Base.connection.execute("select assignments.id as assignment_id from assignments, submissions, grades where assignments.id = submissions.assignment_id and grades.submission_id = submissions.id order by assignments.created_at LIMIT 1")

		#if @lastest != nil && !@lastest.empty?
		#  @lastest = @lastest[0]["assignment_id"]
		#end

		@inGrades = onGrades   
	end

	def validate_admin
		@user = Admin.find_by_id(session[:prof_id])

		if @user == nil
			# User not logged in
			redirect_to "#{root_url}admin/login", :notice => "Sign in first!"
		end
	end

	def latest_assignment
		@latest = Assignment.last
	end

	# Fix the date to be in the expected order 
	# Bootstrap outputs mm/dd/yyyy hh:mm
	# Rails is expecting dd/mm/yyyy hh:mm
	# Swap the day and month and everything works
	def fixDate(date)
		temp = date.scan(/([0-9]+)\/([0-9]+)\/(.*)/)
		if temp.size == 1 && temp[0].size == 3
			return "#{temp[0][1]}/#{temp[0][0]}/#{temp[0][2]}"
		end

		return nil
	end
end
