class DropCaseinUsersTable < ActiveRecord::Migration
  def change
    drop_table :casein_users
  end
end
