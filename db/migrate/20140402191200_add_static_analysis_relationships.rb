class AddStaticAnalysisRelationships < ActiveRecord::Migration
  def change

  	drop_table :static_issues

  	create_table :static_issues do |t|
  		t.integer  :line_number
  		t.string   :type
  		t.text     :description
		t.integer  :static_analysis_id
	end
  end
end
