class AddTypeToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :status, :string
  end
end
