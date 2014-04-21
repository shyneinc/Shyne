class RemovePriceAndBilledFromCall < ActiveRecord::Migration
  def change
    remove_column :calls, :price
    remove_column :calls, :billed
  end
end
