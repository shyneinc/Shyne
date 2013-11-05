class CreateCallHistories < ActiveRecord::Migration
  def change
    create_table :call_histories do |t|
      t.string :sid, index: true
      t.string :status
      t.string :phone_number
      t.decimal :price
      t.integer :duration
      t.references :call

      t.timestamps
    end
  end
end
