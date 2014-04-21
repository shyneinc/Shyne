class AddMetaDataToCallRequests < ActiveRecord::Migration
  def change
    add_column :call_requests, :agenda, :text
    add_column :call_requests, :proposed_duration, :integer
  end
end
