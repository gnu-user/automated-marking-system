class CreateCompilerIssues < ActiveRecord::Migration
  def change
    create_table :compiler_issues do |t|
      t.text :filename

      t.timestamps
    end
  end
end
