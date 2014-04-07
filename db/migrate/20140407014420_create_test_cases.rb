class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string :name
      t.text :description
      t.boolean :sample
      t.integer :assignment_id

      t.timestamps
    end
  end
end
