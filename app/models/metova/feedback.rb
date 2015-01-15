module Metova
  class Feedback
    include ActiveModel::Model

    attr_accessor :body, :type, :device, :referer

    validate :must_have_environment_variables_setup

    def types
      { 'General' => 0, 'Bug Report' => 1, 'Feature Request' => 2 }
    end

    def submit!
      if valid?
        response = http.post 'tasks', project_key: ENV['FLUX_PROJECT_KEY'], task: to_h
        response.success?
      else
        false
      end
    end

    def comments
      [
        "User Agent: #{device}",
        "Referer: #{referer}"
      ]
    end

    def to_h
      {
        actor: '',
        action: "#{types.key(type.to_i)}: #{body}",
        benefit: '',
        task_type: 'admin'
      }
    end

    private

      def http
        @_http ||= Faraday.new(url: ENV['FLUX_API_URL'], headers: headers) do |http|
          http.request :json
          http.adapter :net_http
        end
      end

      def headers
        {
          'Authorization' => "Token token=\"#{ENV['FLUX_PROJECT_TOKEN']}\", project_key=\"#{ENV['FLUX_PROJECT_KEY']}\"",
          'Accept' => '*/*, version=2'
        }
      end

      def must_have_environment_variables_setup
        errors.add :base, 'The feedback URL is not properly setup!' unless ENV['FLUX_API_URL']
        errors.add :base, 'The feedback project key is not properly setup!' unless ENV['FLUX_PROJECT_KEY']
        errors.add :base, 'The feedback project token is not properly setup!' unless ENV['FLUX_PROJECT_TOKEN']
      end

  end
end