class AddCloneIncidentRelationToAssignment < ActiveRecord::Migration
  def change
  	add_column :clone_incidents, :assignment_id, :integer
  end
end
