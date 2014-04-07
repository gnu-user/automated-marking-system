class AddStaticAnalysisRelateToGrade < ActiveRecord::Migration
  def change
  	add_column :static_analyses, :grade_id, :integer
  end
end
