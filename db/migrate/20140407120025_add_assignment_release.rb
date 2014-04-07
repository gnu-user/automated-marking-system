class AddAssignmentRelease < ActiveRecord::Migration
  def change
  	add_column :assignments, :released, :boolean
  end
end
