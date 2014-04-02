class AddCompilerIssueRelationships < ActiveRecord::Migration
  def change

  	drop_table :issues

  	create_table :issues do |t|
  		t.string   :method
  		t.integer  :line_number
  		t.integer  :col_number
  		t.string   :issue_type
  		t.text     :message
  		t.text     :relavent_code
		t.integer  :compiler_issue_id
	end
  end
end
