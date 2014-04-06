class AddTestSample < ActiveRecord::Migration
  def change

  	add_column :tests, :sample, :boolean
  end
end
