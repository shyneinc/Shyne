class RemoveApprovedColsFromMentors < ActiveRecord::Migration
  def change
    remove_column :mentors, :approved, :boolean
    remove_column :mentors, :approved_at, :datetime
  end
end
