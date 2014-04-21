class DropMentorStatusTable < ActiveRecord::Migration
  def change
    drop_table :mentor_statuses
  end
end
