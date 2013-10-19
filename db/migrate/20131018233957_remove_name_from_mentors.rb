class RemoveNameFromMentors < ActiveRecord::Migration
  def change
    remove_column :mentors, :first_name
    remove_column :mentors, :last_name
  end
end
