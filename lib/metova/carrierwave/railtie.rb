require 'carrierwave'

module Metova
  module Carrierwave
    class Railtie < ::Rails::Railtie
      initializer "metova.carrierwave" do |_|

        if ENV['AWS_S3_BUCKET_NAME'] && ENV['AWS_S3_ACCESS_KEY_ID'] && ENV['AWS_S3_SECRET_ACCESS_KEY']
          CarrierWave.configure do |config|
            config.storage = :fog
            config.fog_directory = ENV['AWS_S3_BUCKET_NAME']
            config.fog_public = true
            config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
            config.fog_credentials = {
              provider: 'AWS',
              aws_access_key_id: ENV['AWS_S3_ACCESS_KEY_ID'],
              aws_secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY']
            }
          end
        end

        if ENV['CLOUDFRONT_URL']
          CarrierWave.configure do |config|
            config.asset_host = ENV['CLOUDFRONT_URL']
          end
        end

        if Rails.env.test?
          CarrierWave.configure do |config|
            config.storage = :file
            config.enable_processing = false
          end
        end

      end
    end
  end
end