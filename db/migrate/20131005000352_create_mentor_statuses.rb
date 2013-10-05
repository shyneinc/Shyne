class CreateMentorStatuses < ActiveRecord::Migration
  def change
    create_table :mentor_statuses do |t|
      t.string :title
    end
  end
end
