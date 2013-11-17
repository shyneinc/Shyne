namespace :call  do
  desc "Fetch call duration"
  task :fetch_duration => :environment do
    Call.where(duration: nil, status: :completed).find_each do |call|
      call.fetch_duration
    end
  end
end