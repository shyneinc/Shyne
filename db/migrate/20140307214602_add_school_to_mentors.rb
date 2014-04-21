class AddSchoolToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :schools, :string
  end
end
