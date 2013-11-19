class CreatePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.references :call_request
      t.string :type
      t.decimal :amount
      t.string :status
      t.string :uri
    end

    add_index :payment_transactions, [:call_request_id]
  end
end
