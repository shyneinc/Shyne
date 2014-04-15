ActiveAdmin.register Member do
  menu :priority => 3

  index do
    selectable_column
    column :user
    column :phone_number
    column :industries
    column :city
    column :state
    default_actions
  end

  form do |f|
    f.inputs "Member Details" do
      f.input :phone_number
      f.input :industries
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit member: [:phone_number, :industries, :city, :state, :user_id]
    end
  end
end
