ActiveAdmin.register Member do
  menu :priority => 3

  index do
    selectable_column
    column :user
    column :full_name
    column :phone_number
    default_actions
  end

  form do |f|
    f.inputs "Member Details" do
      f.input :phone_number
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit member: [:phone_number, :user_id]
    end
  end
end
