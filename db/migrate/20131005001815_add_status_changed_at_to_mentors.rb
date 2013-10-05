class AddStatusChangedAtToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :status_changed_at, :datetime
  end
end
