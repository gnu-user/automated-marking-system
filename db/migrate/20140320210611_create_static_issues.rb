class CreateStaticIssues < ActiveRecord::Migration
  def change
    create_table :static_issues do |t|
      t.string :filename
      t.integer :line_number
      t.string :type
      t.string :description

      t.timestamps
    end
  end
end
