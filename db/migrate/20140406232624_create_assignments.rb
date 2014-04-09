class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :admin_id
      t.string :name
      t.datetime :posted
      t.datetime :due
      t.text :description
      t.integer :max_time
      t.integer :attempts
      t.integer :code_weight
      t.integer :test_case_weight

      t.timestamps
    end
  end
end
