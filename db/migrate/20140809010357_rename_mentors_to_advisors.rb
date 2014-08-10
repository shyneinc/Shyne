class RenameMentorsToAdvisors < ActiveRecord::Migration
  def change
    rename_table :mentors, :advisors
  end
end
