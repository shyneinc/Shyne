class RemoveConferencesidFromCallRequest < ActiveRecord::Migration
  def change
    remove_column :call_requests, :conferencesid
  end
end
