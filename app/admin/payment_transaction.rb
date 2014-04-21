ActiveAdmin.register PaymentTransaction do
  menu :priority => 6

  index do
    selectable_column
    column :call_request_id
    column :type
    column :amount
    column :status
    default_actions
  end

  form do |f|
    f.inputs "Payment Transaction Details" do
      f.input :call_request, collection: CallRequest.all
      f.input :uri
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit call_request: []
    end
  end
end
