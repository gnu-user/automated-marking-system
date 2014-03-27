class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.text :text_line

      t.timestamps
    end
  end
end
