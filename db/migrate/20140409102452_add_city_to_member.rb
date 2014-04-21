class AddCityToMember < ActiveRecord::Migration
  def change
    add_column :members, :city, :string
    add_column :members, :state, :string
  end
end
