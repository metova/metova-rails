module Metova
  module SMTP
    class Railtie < ::Rails::Railtie

      initializer "metova.smtp" do |app|
        if ENV['METOVA_SMTP_USERNAME'] && ENV['METOVA_SMTP_PASSWORD'] && ENV['METOVA_SMTP_ADDRESS'] && ENV['METOVA_SMTP_PORT']
          app.config.action_mailer.delivery_method = :smtp
          app.config.action_mailer.default_url_options = { host: ENV['METOVA_SMTP_DEFAULT_HOST'] }
          app.routes.default_url_options = app.config.action_mailer.default_url_options

          app.config.action_mailer.smtp_settings = {
            address: ENV['METOVA_SMTP_ADDRESS'],
            port: ENV['METOVA_SMTP_PORT'],
            enable_starttls_auto: true,
            authentication: 'login',
            user_name: ENV['METOVA_SMTP_USERNAME'],
            password: ENV['METOVA_SMTP_PASSWORD'],
          }

          app.config.action_mailer.smtp_settings.merge! domain: ENV['METOVA_SMTP_DOMAIN'] if ENV['METOVA_SMTP_DOMAIN']
        end
      end

    end
  end
end
