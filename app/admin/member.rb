ActiveAdmin.register Member do
  menu :priority => 3

  index do
    selectable_column
    column :first_name
    column :last_name
    default_actions
  end

  form do |f|
    f.inputs "Member Details" do
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit member: [:first_name, :last_name]
    end
  end
end
