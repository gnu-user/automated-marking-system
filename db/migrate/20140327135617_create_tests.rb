class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.text :description
      t.boolean :result

      t.timestamps
    end
  end
end
