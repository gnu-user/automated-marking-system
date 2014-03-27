class CreateIoElements < ActiveRecord::Migration
  def change
    create_table :io_elements do |t|
      t.text :value
      t.boolean :input

      t.timestamps
    end
  end
end
