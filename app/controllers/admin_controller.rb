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

require "#{Rails.root}/lib/tasks/clone/clone_detector"

class AdminController < ApplicationController

	def index
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		@assignments = ActiveRecord::Base.connection.execute("select assignments.id as id, assignments.name as name, assignments.posted as posted, assignments.due as due, COUNT(submissions.id) as submissions, AVG(grades.final) as final_grade from assignments LEFT OUTER JOIN submissions ON assignments.id = submissions.assignment_id LEFT OUTER JOIN grades ON submissions.id = grades.submission_id GROUP BY assignments.id")

		#TODO fix these numbers
		@review_submissions = 0
		@view_assignment = 0
		@resolve_issues = 0
	end

	def new
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		@assignment = Assignment.new
	end

	def grading
		validate_admin
		latest_assignment
		getHeaderInfo(1)

		@assignment_id = params[:id].to_i

		@grades = ActiveRecord::Base.connection.execute("select students.first_name as firstname, students.last_name as lastname, students.student_id as student_id, assignments.code_weight as code_weight, grades.code as code_grade, assignments.test_case_weight as test_case_weight, grades.testcase as test_case_grade, grades.final as final_grade from students, assignments, submissions, grades where students.id = submissions.student_id and assignments.id = submissions.assignment_id and submissions.id = grades.submission_id and assignments.id = #{@assignment_id}")

		#TODO call this once the grades are requested to be downloaded

		#Create csv
		if @grades != nil
			# Add the header to the csv
			#csvFile = "Last Name,First Name,Student Number,Metrics Grade,Metrics Weight,Test Case Grade,Test Case Weight,Final Grade"

			#@grades.each do |grade|
			#	csvFile += "#{grades["firstname"]},#{grades["lastname"]},#{grades["student_id"]},#{grades["code_grade"].to_f},#{grades["code_weight"]},#{grades["test_case_grade"].to_f},#{grades["test_case_weight"]},#{grades["final_grade"].to_f}\n"
			#end
			# Remove the trailing new line
			#csvFile = csvFile[0..-2]

      respond_to do |format|
        format.csv { render csv: @grades, filename: params[:csv_file], header: "First Name,Last Name,Student Number,Metrics Weight,Metrics Grade,Test Case Weight,Test Case Grade,Final Grade" }
      end
		end
	end

	def cheat
		validate_admin
		latest_assignment
		getHeaderInfo(2)

		@assignment_id = params[:id].to_i
		admin_id = session[:prof_id].to_i

		#subs = Submission.where("assignment_id = #{@assignment_id.to_i}")

		@cheating = ActiveRecord::Base.connection.execute("select clone_incidents.id, clone_incidents.similarity, diff_files.name from  clone_incidents, diff_files where clone_incidents.id = diff_files.clone_incident_id and clone_incidents.assignment_id = #{@assignment_id.to_i} order by clone_incidents.id")

		index = 0
		while index < @cheating.size
			# Get the first student's record
			fileParsed = @cheating[index]["name"].scan(/clone_[0-9_]+\/([0-9]+)_[0-9]+\.cpp/)
			filename = fileParsed[0][0]
			@cheating[index]["first_student"] = Student.find_by_id (filename) 

			# Get the second student's record			
			fileParsed = @cheating[index+1]["name"].scan(/clone_[0-9_]+\/([0-9]+)_[0-9]+\.cpp/)
			second = fileParsed[0][0]
			@cheating[index]["second_student"] = Student.find_by_id (second)

			index+=2
		end
	end

	def runCheatDetection
		validate_admin

		admin_id = session[:prof_id].to_i
		@assignment_id = params[:id].to_i

		subs = Submission.where("assignment_id = #{@assignment_id.to_i}")

		@size = subs.empty?

		directory = "clone_#{admin_id}_#{@assignment_id}"

		if Dir.exist?(directory)
			FileUtils.rm_r(directory)
		end

		Dir.mkdir(directory)

		subs.each do |sub|
			fileName = "#{directory}/#{sub.student_id}_#{@assignment_id}"
		    file = File.new("#{fileName}.cpp",'w')
		    file.puts(sub.code)
		    file.close
		end

		clone_detector = CloneDetector.new(directory)
		clone_detector.process
		clone_detector.parseOutput(@assignment_id)

		FileUtils.rm_r(directory)

		redirect_to "#{root_url}admin/grades/#{@assignment_id}/cheating"
	end

	def showDiff
		validate_admin
		latest_assignment
		getHeaderInfo(2)

		assignment_id = params[:id].to_i
		clone_id = params[:clone_id]
		@first_student = params[:first].to_i
		@second_student = params[:second].to_i

		# Get the diff entries
		@clone_incidents = ActiveRecord::Base.connection.execute("select clone_incidents.similarity, diff_files.name, diff_entries.position, diff_entries.id as diff_entry_id from clone_incidents, diff_files, diff_entries where clone_incidents.assignment_id = #{assignment_id} and clone_incidents.id = diff_files.clone_incident_id and diff_files.id = diff_entries.diff_file_id and clone_incidents.id = #{clone_id}")

		if @clone_incidents
			@clone_incidents[0]["person"] = Student.find_by_id(@first_student)
			@clone_incidents[1]["person"] = Student.find_by_id(@second_student)
			@clone_incidents.each do |incident|

				incident["code"] = Line.find_all_by_diff_entry_id(incident["diff_entry_id"])
			end
		else
			redirect_to "#{root_url}admin/#{assignment_id}/cheating"
		end
	end

	def show
		validate_admin
		latest_assignment
		getHeaderInfo(0)

		@assignment_id = params[:id].to_i
		@assignment = Assignment.find_by_id(@assignment_id)

		if @assignment == nil
			#TODO give error message
			redirect_to "#{root_url}admin", :notice => "No Activity found!"
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
			redirect_to "#{root_url}admin/new", flash: {alert: @assignment.errors.full_messages}
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

		if TestCase.where("assignment_id = #{session[:assignment_id].to_i} AND sample = 't'").count <= 0
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
