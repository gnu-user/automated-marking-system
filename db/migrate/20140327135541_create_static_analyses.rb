class CreateStaticAnalyses < ActiveRecord::Migration
  def change
    create_table :static_analyses do |t|
      t.string :filename

      t.timestamps
    end
  end
end
