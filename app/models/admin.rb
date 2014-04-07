class Admin < ActiveRecord::Base
  include User

  validates_presence_of :prof_id
  validates_uniqueness_of :prof_id
end
