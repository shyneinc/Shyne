class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.references :member, index: true
      t.references :mentor, index: true
      t.timestamp :scheduled_at
      t.decimal :duration

      t.timestamps
    end
  end
end
