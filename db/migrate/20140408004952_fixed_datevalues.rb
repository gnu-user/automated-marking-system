class FixedDatevalues < ActiveRecord::Migration
  def up
  	remove_column :assignments, :posted
  	remove_column :assignments, :due
  	add_column :assignments, :posted, :datetime
  	add_column :assignments, :due, :datetime 
  end

  def down
	change_column :assignments, :posted, :date
	change_column :assignments, :due, :date
  end
end
