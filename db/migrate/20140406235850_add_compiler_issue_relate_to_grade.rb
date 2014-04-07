class AddCompilerIssueRelateToGrade < ActiveRecord::Migration
  def change
  	add_column :compiler_issues, :grade_id, :integer
  end
end
