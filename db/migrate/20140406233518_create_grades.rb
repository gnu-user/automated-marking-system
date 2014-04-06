class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.float :final
      t.float :testcase
      t.float :code

      t.timestamps
    end
  end
end
