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
class UserSessionsController < ApplicationController
  def initialize(controller, type, id)
    @controller = controller
    @type = type
    @id = id
  end

  def create(landing_page, post_logout_page)
    user = @controller.authenticate(params[@type][:email], params[@type][:password])

    if user
      session[@id] = user.id
      redirect_to landing_page, notice: "Logged in!"
    else
      flash[:alert] = "Invalid email or password"
      redirect_to post_logout_page
    end
  end

  def destroy(post_logout_page)
    session[@type] = nil
    redirect_to post_logout_page, notice: "Logged out!"
  end
end