class AddPasscodeToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :passcode, :integer , limit: 2
  end
end
