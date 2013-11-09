ActiveAdmin.register Call do
  menu :priority => 4

  index do
    selectable_column
    column :call_request_id
    column :sid
    column :conferencesid
    column :status
    column :from_number
    column :duration
    column :price
    column :billed
    default_actions
  end

  form do |f|
    f.inputs "Call Details" do
      # f.input :call_request_id, as: :select, collection: CallRequest.all.pluck('id')
      f.input :sid
      f.input :conferencesid
      f.input :status , as: :select, collection: CallStatus.select_options, include_blank: false
      f.input :from_number
      f.input :duration
      f.input :price
      f.input :billed
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit call: [:call_request_id, :sid, :conferencesid, :status, :from_number, :duration, :price, :billed]
    end
  end

  
end