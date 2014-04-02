class AddCloneIncidentRelationships < ActiveRecord::Migration
  def change

  	drop_table :diff_files
	drop_table :diff_entries
	drop_table :lines

  	create_table :diff_files do |t|
  		t.string   :name
		t.integer  :clone_incident_id
	end

	
	create_table :diff_entries do |t|
  		t.string   :position
		t.integer  :diff_file_id
	end

	create_table :lines do |t|
  		t.text     :text_line
		t.integer  :diff_entry_id
	end
  end
end
