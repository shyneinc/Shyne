class AddConferencesidToCallHistories < ActiveRecord::Migration
  def change
    add_column :call_histories, :conferencesid, :string
    add_column :call_histories, :billed, :boolean
  end
end
