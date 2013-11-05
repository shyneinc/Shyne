class ChangeMentorStatusCol < ActiveRecord::Migration
  def change
    remove_column :mentors, :mentor_status_id
    add_column :mentors, :mentor_status, :string
  end
end
