class Student < ActiveRecord::Base
  include User

  validates_presence_of :student_id
  validates_uniqueness_of :student_id
end
