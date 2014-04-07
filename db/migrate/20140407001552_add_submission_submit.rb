class AddSubmissionSubmit < ActiveRecord::Migration
  def change
  	add_column :submissions, :submit_count, :integer
  end
end
