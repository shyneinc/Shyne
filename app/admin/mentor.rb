ActiveAdmin.register Mentor do
  menu :priority => 2

  index do
    column :first_name
    column :last_name
    column :headline
    column :years_of_experience
    column :approved
    column :approved_at
    default_actions
  end

  form do |f|
    f.inputs "Mentor Details" do
      f.input :first_name
      f.input :last_name
      f.input :headline
      f.input :years_of_experience
      f.input :phone_number
      f.input :availability
      f.input :approved
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit mentor: [:first_name, :last_name, :headline, :years_of_experience, :phone_number,
                             :availability, :approved]
    end
  end
end
