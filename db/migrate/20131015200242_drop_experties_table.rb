class DropExpertiesTable < ActiveRecord::Migration
  def change
    drop_table :experties
  end
end
