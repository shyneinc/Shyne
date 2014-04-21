ActiveAdmin.register Mentor do
  menu :priority => 2

  index do
    selectable_column
    column :user
    column :city
    column :state
    column :headline
    column :years_of_experience
    column :linkedin
    column :mentor_status
    column :featured
    default_actions
  end

  form do |f|
    f.inputs "Mentor Details" do
      f.input :city
      f.input :state
      f.input :headline
      f.input :years_of_experience
      f.input :linkedin
      f.input :phone_number
      f.input :availability
      f.input :mentor_status, as: :select, collection: MentorStatus.select_options
      f.input :featured
    end

    f.actions
  end

  controller do
    def permitted_params
      params.permit mentor: [:city, :state, :headline, :years_of_experience, :linkedin, :phone_number,
                             :availability, :mentor_status, :featured, :user_id]
    end
  end
end
