class StudentController < ApplicationController
  layout "code", only: [:show]

  def index
    @title = 'Student'
  end

  def assignment 
  end

  def show

  end
end
