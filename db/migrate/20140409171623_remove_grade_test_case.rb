class RemoveGradeTestCase < ActiveRecord::Migration
  def change
  	remove_column :grades, :test_cases
  end
end
