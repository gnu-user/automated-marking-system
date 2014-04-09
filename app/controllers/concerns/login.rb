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
module Login
  private


  def save(user, post_url, params)
    if params[:t_and_c] === "1"
      if user.save
        redirect_to post_url, notice: "Signed up!"
      else
        redirect_to post_url, flash: {register: user.errors}
      end
    else
      redirect_to post_url, flash: {alert: "Please Accept Terms & Conditions"}
    end
  end

  def user_params(type, id)
    params.require(type).permit(:first_name, :last_name, id, :email, :password, :password_confirmation)
  end
end
