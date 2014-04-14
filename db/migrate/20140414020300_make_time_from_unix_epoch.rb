class MakeTimeFromUnixEpoch < ActiveRecord::Migration
  def change
    change_column :assignments, :posted, :integer
    change_column :assignments, :due, :integer
  end
end
