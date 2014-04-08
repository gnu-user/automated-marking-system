class RemoveTestCaseReference < ActiveRecord::Migration
  def change
  	remove_column :assignments, :test_cases
  end
end
