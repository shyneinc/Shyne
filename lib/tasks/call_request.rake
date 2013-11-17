namespace :call_request  do
  desc "Calculate billable duration of the call request"
  task :calculate_billable_duration => :environment do
    CallRequest.where(billable_duration: nil, status: :approved).find_each do |call_request|
      call_request.calculate_billable_duration
    end
  end
end