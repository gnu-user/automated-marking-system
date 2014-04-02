class AddTestRelationships < ActiveRecord::Migration
  def change

  	drop_table :io_elements

  	create_table :io_elements do |t|
  		t.text     :value
  		t.boolean  :input
		t.integer  :test_id
	end
  end
end
