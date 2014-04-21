class AddMetaDataToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :headline, :text
    add_column :mentors, :years_of_experience, :integer

    add_column :mentors, :phone_number, :string
    add_column :mentors, :availability, :text

    add_column :mentors, :approved, :boolean
    add_column :mentors, :approved_at, :datetime
  end
end
