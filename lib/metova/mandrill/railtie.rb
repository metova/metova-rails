module Metova
  module Mandrill
    class Railtie < ::Rails::Railtie

      initializer "metova.mandrill" do |app|
        if ENV['MANDRILL_DOMAIN']

          app.config.action_mailer.default_url_options = { host: (ENV['MANDRILL_DEFAULT_HOST'] || ENV['MANDRILL_DOMAIN']) }
          app.config.action_mailer.delivery_method = :smtp
          app.config.action_mailer.smtp_settings = {
            address: 'smtp.mandrillapp.com',
            port: 587,
            enable_starttls_auto: true,
            authentication: 'login',
            user_name: ENV['MANDRILL_USERNAME'],
            password: ENV['MANDRILL_PASSWORD'],
            domain: ENV['MANDRILL_DOMAIN']
          }

          app.routes.default_url_options = app.config.action_mailer.default_url_options

        end
      end

    end
  end
end