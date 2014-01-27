class RenameProgramsToMentors < ActiveRecord::Migration
  def change
    remove_column :mentors, :experties
    rename_column :mentors, :programs, :skills
  end
end
