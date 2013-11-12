class AddLocationToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :location, :string
  end
end
