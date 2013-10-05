class AddStatusToMentors < ActiveRecord::Migration
  def change
    add_reference :mentors, :mentor_status, index: true
  end
end
