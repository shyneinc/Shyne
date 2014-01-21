class RenameDataTypeOnWorkHistories < ActiveRecord::Migration
  def change
    rename_column :work_histories, :date_started, :year_started
    rename_column :work_histories, :date_ended, :year_ended
    
    change_column :work_histories, :year_started, :string
    change_column :work_histories, :year_ended, :string
  end
end
