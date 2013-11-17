class RemovePriceAndBilledFromCallRequest < ActiveRecord::Migration
  def change
    remove_column :call_requests, :price
    remove_column :call_requests, :billed
  end
end
