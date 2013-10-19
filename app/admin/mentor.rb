ActiveAdmin.register Mentor do
  menu :priority => 2

  index do
    selectable_column
    column :full_name
    column :headline
    column :years_of_experience
    column :mentor_status
    column :featured
    default_actions
  end

  form do |f|
    f.inputs "Mentor Details" do
      f.input :headline
      f.input :experties
      f.input :years_of_experience
      f.input :phone_number
      f.input :availability
      f.input :mentor_status
      f.input :featured
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit mentor: [:headline, :experties, :years_of_experience, :phone_number,
                             :availability, :mentor_status_id, :featured]
    end
  end
end
