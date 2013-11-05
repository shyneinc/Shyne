class RemoveSidAndStateFromCalls < ActiveRecord::Migration
  def change
    remove_column :calls, :sid
    remove_column :calls, :state
    remove_column :calls, :status
  end
end
