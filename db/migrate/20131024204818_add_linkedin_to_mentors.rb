class AddLinkedinToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :linkedin, :string
  end
end
