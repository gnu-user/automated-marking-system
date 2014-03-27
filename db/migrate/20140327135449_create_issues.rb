class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :method
      t.integer :line_number
      t.integer :col_number
      t.string :issue_type
      t.text :message
      t.text :relavent_code

      t.timestamps
    end
  end
end
