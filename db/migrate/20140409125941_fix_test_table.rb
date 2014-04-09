class FixTestTable < ActiveRecord::Migration
  def change

  	drop_table :tests
  	drop_table :io_elements

  	create_table :tests do |t|
      t.integer :test_case_id
      t.boolean :result
      t.integer :grade_id
      t.timestamps
    end
  end
end
