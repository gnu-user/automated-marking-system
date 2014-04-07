class AddGradeRelationship < ActiveRecord::Migration
  def change
  	add_column :grades, :submission_id, :integer
  end
end
