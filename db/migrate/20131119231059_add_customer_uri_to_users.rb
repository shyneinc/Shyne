class AddCustomerUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_uri, :string
  end
end
