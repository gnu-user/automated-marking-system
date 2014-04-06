class Admin < ActiveRecord::Base
  include User

  validates_presence_of :prof
  validates_uniqueness_of :prof
end
