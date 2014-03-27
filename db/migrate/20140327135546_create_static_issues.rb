class CreateStaticIssues < ActiveRecord::Migration
  def change
    create_table :static_issues do |t|
      t.integer :line_number
      t.string :type
      t.text :description

      t.timestamps
    end
  end
end
