ActiveAdmin.register CallRequest do
  menu :priority => 5

  index do
    selectable_column
    column :passcode
    column :mentor_id
    column :member_id
    column :scheduled_at
    column :status
    column :billable_duration
    default_actions
  end

  form do |f|
    f.inputs "Call Request Details" do
      f.input :mentor, collection: Mentor.all
      f.input :member, collection: Member.all
      f.input :scheduled_at, :as => :just_datetime_picker
      f.input :status, as: :select, collection: CallRequestStatus.select_options, include_blank: false
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit call_request: [:mentor_id, :member_id, :status, :scheduled_at, :scheduled_at_date, :scheduled_at_time_hour, :scheduled_at_time_minute]
    end
  end
end
