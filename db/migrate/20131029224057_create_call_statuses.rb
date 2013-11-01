class CreateCallStatuses < ActiveRecord::Migration
  def change
    create_table :call_statuses do |t|
      t.string "type"
      t.timestamps
    end
  end
end
