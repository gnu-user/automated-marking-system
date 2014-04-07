class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.text :value
      t.boolean :input
      t.integer :test_case_id

      t.timestamps
    end
  end
end
