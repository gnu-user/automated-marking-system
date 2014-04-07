class AddTestRelations < ActiveRecord::Migration
  def change

  	add_column :assignments, :test_cases, :integer

  	add_column :grades, :test_cases, :integer
  end
end
