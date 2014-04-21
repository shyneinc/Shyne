CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage = :fog
    config.fog_credentials = {
        :provider => "AWS",
        :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
        :aws_secret_access_key => ENV['AWS_SECRET_KEY']
    }
    config.fog_directory = ENV['AWS_BUCKET']
    config.asset_host = ENV['AWS_CDN'] if ENV.key?('AWS_CDN')
  elsif Rails.env.development?
    config.storage = :file
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  end
end