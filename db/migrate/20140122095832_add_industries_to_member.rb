class AddIndustriesToMember < ActiveRecord::Migration
  def change
    add_column :members, :industries, :string, :after => :phone_number
  end
end
