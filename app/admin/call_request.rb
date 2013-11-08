ActiveAdmin.register CallRequest do
  menu :priority => 4

  index do
    selectable_column
    column :mentor_id
    column :member_id
    column :scheduled_at
    default_actions
  end

  form do |f|
    f.inputs "Call Details" do
      f.input :mentor
      f.input :member
      f.input :scheduled_at, :as => :just_datetime_picker
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit call: [:mentor_id, :member_id, :scheduled_at, :scheduled_at_date, :scheduled_at_time_hour, :scheduled_at_time_minute]
    end
  end
end
