class AddPriceAndBilledToCallRequests < ActiveRecord::Migration
  def change
    add_column :call_requests, :price, :float
    add_column :call_requests, :billed, :boolean
  end
end
