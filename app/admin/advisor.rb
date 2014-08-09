ActiveAdmin.register Advisor do
  menu :priority => 2

  index do
    selectable_column
    column :user
    column :city
    column :state
    column :headline
    column :years_of_experience
    column :linkedin
    column :advisor_status
    column :featured
    default_actions
  end

  form do |f|
    f.inputs "Advisor Details" do
      f.input :city
      f.input :state
      f.input :headline
      f.input :years_of_experience
      f.input :linkedin
      f.input :phone_number
      f.input :availability
      f.input :advisor_status, as: :select, collection: AdvisorStatus.select_options
      f.input :featured
    end

    f.actions
  end

  controller do
    def permitted_params
      params.permit advisor: [:city, :state, :headline, :years_of_experience, :linkedin, :phone_number,
                             :availability, :advisor_status, :featured, :user_id]
    end
  end
end
