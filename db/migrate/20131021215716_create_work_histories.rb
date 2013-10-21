class CreateWorkHistories < ActiveRecord::Migration
  def change
    create_table :work_histories do |t|
      t.string :company
      t.date :date_started
      t.date :date_ended
      t.boolean :current_work
      t.belongs_to :mentor

      t.timestamps
    end
  end
end
