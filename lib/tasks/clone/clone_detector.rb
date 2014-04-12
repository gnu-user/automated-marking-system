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
require_relative '../manager'

class CloneDetector < Manager

    CLONE_PARSER = /(.*?.cpp) consists for ([0-9]{1,3} %) of (.*.cpp) material/

    #This could break if they have a line similar to the output file
    #[0] => first file path, [1] = first line location, [2] => second file path, [3] => second line location, [4] => diff percent
    CLONE_DIFF_PARSER = /(.*?.cpp): line ([0-9\-]+)\s*\|(.*?.cpp): line ([0-9\-]+)[\s]*\[([0-9]+)\]/
    COMMAND = 'sim_c'
    OPTIONS = '-e -n -P -R -T -t 1 -r 12'
    OPTIONS_DIFF = "-T -t 1 -r 12"
    OUTPUT = '>'
    FILE = 'clone_temp.txt'

    def checkDirectoryExist
        checkFileExist
    end

    def applyCloneDetection
        process
    end

    def process
        super

        @output = Array.new
        result = %x(#{COMMAND} #{OPTIONS} #{@path_to_file})

        result.each_line do |line|
               @output.push(line)
        end        

        @output
    end

    def parseOutput(assignment_id)

        clone_incidents = CloneIncident.where("assignment_id = #{assignment_id}")

        clone_incidents.each do |clone_incident|
            diff_files = DiffFile.where("clone_incident_id = #{clone_incident.id}")
           
            diff_files.each do |diff_file|
                diff_entries = DiffEntry.find_by_diff_file_id(diff_file.id)

                Line.where("diff_entry_id = #{diff_entries.id}").delete_all
                diff_entries.delete
            end
            diff_files.delete_all
        end
        clone_incidents.delete_all

        #incidents = Array.new
        @output.each do |line|
            #[0] == first file, [1] == percent similarity, [2] == second file
            parsed = line.scan(CLONE_PARSER)

            #first_file_name = line[0][0]
            #second_file_name = 
            #puts parsed
            cloneIncident = CloneIncident.new
            cloneIncident.assignment_id = assignment_id
            cloneIncident.similarity = parsed[0][1]
            cloneIncident.save

            firstDiffFile = DiffFile.new
            firstDiffFile.name = parsed[0][0]
            firstDiffFile.clone_incident_id = cloneIncident.id
            firstDiffFile.save

            secondDiffFile = DiffFile.new
            secondDiffFile.name = parsed[0][2]
            secondDiffFile.clone_incident_id = cloneIncident.id
            secondDiffFile.save
            
            #incidents[-1].diff = Array.new
            size = 0

            #puts incidents[-1]#.first_file.name
            #puts incidents[-1]#.second_file.name
            #a = gets
            diff_out = %x(#{COMMAND} #{OPTIONS_DIFF} #{firstDiffFile.name} #{secondDiffFile.name})
            #puts diff_out

            firstDiffEntry = nil
            secondDiffEntry = nil

            diff_out.each_line do |line|
                diff_parser = line.scan(CLONE_DIFF_PARSER)

				#puts line
               	#a = gets

                if diff_parser != []
                    size = line.split("|")[0].size
                    firstDiffEntry = DiffEntry.new
                    firstDiffEntry.position = diff_parser[0][1]
                    firstDiffEntry.diff_file_id = firstDiffFile.id
                    firstDiffEntry.save

                    secondDiffEntry = DiffEntry.new
                    secondDiffEntry.position = diff_parser[0][3]
                    secondDiffEntry.diff_file_id = secondDiffFile.id
                    secondDiffEntry.save
                   
                else
                    firstFile = Line.new
                    firstFile.diff_entry_id = firstDiffEntry.id
                    secondFile = Line.new
                    secondFile.diff_entry_id = secondDiffEntry.id

                    f1_line = line[0..size-1]
                    f2_line = line[size+1..-1]

                    #puts f1_line
                    #puts f2_line
                    #a = gets

                    firstFile.text_line = f1_line
                    secondFile.text_line = f2_line
                    firstFile.save
                    secondFile.save
                end
            end        
        end
        #return incidents
    end
end