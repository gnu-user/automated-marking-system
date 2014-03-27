class CreateCloneIncidents < ActiveRecord::Migration
  def change
    create_table :clone_incidents do |t|
      t.integer :similarity

      t.timestamps
    end
  end
end
