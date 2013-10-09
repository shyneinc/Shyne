class AddFeaturedColToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :featured, :boolean
  end
end
