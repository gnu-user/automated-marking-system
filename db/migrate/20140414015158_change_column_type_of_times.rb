class ChangeColumnTypeOfTimes < ActiveRecord::Migration
  def change
    change_column :assignments, :posted, :string
    change_column :assignments, :due, :string
  end
end
