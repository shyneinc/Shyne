CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
        :provider => "AWS",
        :aws_access_key_id => ENV['aws_access_key'],
        :aws_secret_access_key => ENV['aws_secret_key']
    }
    config.fog_directory = ENV['aws_bucket']
  elsif Rails.env.development?
    config.storage = :file
  else
    config.storage = :file
    config.enable_processing = false
  end
end