class ChangeMentorStatusCol < ActiveRecord::Migration
  def change
    add_column :mentors, :mentor_status, :string
  end
end
