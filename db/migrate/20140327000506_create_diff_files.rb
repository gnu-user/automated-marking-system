class CreateDiffFiles < ActiveRecord::Migration
  def change
    create_table :diff_files do |t|
      t.string :name

      t.timestamps
    end
  end
end
