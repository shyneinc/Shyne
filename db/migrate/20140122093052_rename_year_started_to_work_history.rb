class RenameYearStartedToWorkHistory < ActiveRecord::Migration
  def change
    rename_column :work_histories, :year_started, :date_started
    rename_column :work_histories, :year_ended, :date_ended    
  end
end
