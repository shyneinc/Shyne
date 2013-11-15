class RemoveSettingsColFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :settings
  end
end
