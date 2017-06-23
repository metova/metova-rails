module Metova
  module SMTP
    class Railtie < ::Rails::Railtie
      initializer 'metova.smtp' do |app|
        next unless address.present? && port.present? && username.present? && password.present?

        app.config.action_mailer.delivery_method = :smtp
        app.config.action_mailer.smtp_settings = smtp_settings
        app.config.action_mailer.smtp_settings[:domain] = domain if domain.present?
        app.routes.default_url_options = app.config.action_mailer.default_url_options = { host: host } if host.present?
      end

      private
        def smtp_settings
          @smtp_settings ||= {
            enable_starttls_auto: true,
            authentication: 'login',
            address: address,
            port: port,
            username: username,
            password: password
          }
        end

        def domain
          ENV.fetch 'METOVA_SMTP_DOMAIN', Rails.application.secrets.metova_smtp_domain
        end

        def host
          ENV.fetch 'METOVA_SMTP_HOST', Rails.application.secrets.metova_smtp_host
        end

        def address
          ENV.fetch 'METOVA_SMTP_ADDRESS', Rails.application.secrets.metova_smtp_address
        end

        def port
          ENV.fetch 'METOVA_SMTP_PORT', Rails.application.secrets.metova_smtp_port
        end

        def username
          ENV.fetch 'METOVA_SMTP_USERNAME', Rails.application.secrets.metova_smtp_username
        end

        def password
          ENV.fetch 'METOVA_SMTP_PASSWORD', Rails.application.secrets.metova_smtp_password
        end
    end
  end
end
