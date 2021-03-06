class RenameMentorReferences < ActiveRecord::Migration
  def change
    rename_column :advisors, :mentor_status, :advisor_status
    rename_column :call_requests, :mentor_id, :advisor_id
    rename_column :reviews, :mentor_id, :advisor_id
    rename_column :work_histories, :mentor_id, :advisor_id

    User.where(:role_type => 'Mentor').update_all(:role_type => 'Advisor')
  end
end
