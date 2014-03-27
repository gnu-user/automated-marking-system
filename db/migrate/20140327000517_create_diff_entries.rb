class CreateDiffEntries < ActiveRecord::Migration
  def change
    create_table :diff_entries do |t|
      t.string :position

      t.timestamps
    end
  end
end
