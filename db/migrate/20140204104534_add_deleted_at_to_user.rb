class AddDeletedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime, :default => nil, :after => :customer_uri
  end
end
