class AddTimestampsToPaymentTransactions < ActiveRecord::Migration
  def change
    add_timestamps(:payment_transactions)
  end
end
