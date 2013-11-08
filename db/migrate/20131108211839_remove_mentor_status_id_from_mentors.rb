class RemoveMentorStatusIdFromMentors < ActiveRecord::Migration
  def change
    remove_column :mentors, :mentor_status_id
  end
end
