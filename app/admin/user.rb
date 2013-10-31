ActiveAdmin.register User do
  menu :priority => 1

  index do
    selectable_column
    column :first_name
    column :last_name
    column :email
    column "Type", :role_type
    column "Confirmed", :confirmed?
    default_actions
  end

  form do |f|
    f.inputs "Mentor Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit mentor: [:first_name, :last_name, :email, :time_zone]
    end
  end
end
