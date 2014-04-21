class AddExpertiesToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :experties, :string, array: true, default: []
    add_index  :mentors, :experties, using: 'gin'
  end
end
