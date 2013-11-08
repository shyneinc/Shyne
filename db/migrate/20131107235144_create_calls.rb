class CreateCalls < ActiveRecord::Migration
  def change
    drop_table :calls
    create_table :calls do |t|
      t.references :call_request, index: true
      t.string :sid, index: true
      t.string :conferencesid, index: true
      t.string :status
      t.string :from_number
      t.float :price
      t.integer :duration
      t.boolean :billed
      t.timestamps
    end
  end
end
