class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text :code
      t.integer :assignment_id

      t.timestamps
    end
  end
end
