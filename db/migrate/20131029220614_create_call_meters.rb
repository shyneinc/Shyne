class CreateCallMeters < ActiveRecord::Migration
  def change
    create_table :call_meters do |t|

      t.timestamps
    end
  end
end
