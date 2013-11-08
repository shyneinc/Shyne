class CreateCallRequests < ActiveRecord::Migration
  def change
    create_table :call_requests do |t|
      t.references :member, index: true
      t.references :mentor, index: true
      t.integer :passcode, limit: 3
      t.string :status
      t.timestamp :scheduled_at
      t.timestamps
    end
  end
end
