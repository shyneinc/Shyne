ActiveAdmin.register User do
  menu :priority => 1

  index do
    selectable_column
    column :username
    column :first_name
    column :last_name
    column :email
    column :time_zone
    column "Role Type", :role_type
    column "Role Group", :role
    column "Confirmed", :confirmed?
    default_actions
  end

  form do |f|
    f.inputs "Mentor Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :time_zone, as: :select, collection: ActiveSupport::TimeZone.us_zones.map(&:name), include_blank: false
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:first_name, :last_name, :email, :password, :password_confirmation, :time_zone]
    end
  end
end
