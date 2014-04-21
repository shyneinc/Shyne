class AddBillableDurationToCallRequests < ActiveRecord::Migration
  def change
    add_column :call_requests, :billable_duration, :integer
    add_column :call_requests, :conferencesid, :string
  end
end
