class StudentController < ApplicationController
  layout "student"
  layout "code", only: [:show]

  def index
    #@title = 'AMSStudent'
  end

  def assignment 
  end

  def show

  end
end
