class AddStateAndSidToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :state, :string
    add_column :calls, :sid, :string
  end
end
