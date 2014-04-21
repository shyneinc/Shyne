class AddPriceAndBilledToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :price, :float
    add_column :calls, :billed, :boolean
  end
end
