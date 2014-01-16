class AddCityToMentor < ActiveRecord::Migration
  def change
    add_column :mentors, :city, :string, :after => :location
    add_column :mentors, :state, :string, :after => :city
  end
end
