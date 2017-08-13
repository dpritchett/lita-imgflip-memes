require 'pry'

module Lita
  module Handlers
    class ImgflipMemes < Handler
      class ImgflipApiError < StandardError; end
      class ConnectionError < StandardError; end

      config :api_user, default: ENV['IMGFLIP_API_USER']
      config :api_password, default: ENV['IMGFLIP_API_PASSWORD']

      API_URL = 'https://api.imgflip.com/caption_image'

      @@_templates = []

      def make_meme(message)
        line1, line2 = extract_meme_text(message.match_data)

        template = find_template(message.pattern)

        begin
          image = pull_image(template.fetch(:template_id), line1, line2)
        rescue ConnectionError, ImgflipApiError => err
          Lita.logger.error(err.message)
          return message.reply 'Bummer - can\'t connect to Imgflip.'
        end

        message.reply image
      end

      def extract_meme_text(match_data)
        _, line1, line2 = match_data.to_a
        return line1, line2
      end

      def find_template(pattern)
        template = registered_templates.select { |t| t.fetch(:pattern) == pattern }.first
        raise ArgumentError if template.nil?
        return template
      end

      def pull_image(template_id, line1, line2)
        username = config.api_user
        password = config.api_password

        begin
          result = http.post API_URL, { 
            template_id: template_id,
            username: username,
            password: password,
            text0: line1,
            text1: line2
          } 
        rescue Faraday::Error => err
          raise ConnectionError, err.message
        end

        # clean me up
        parsed = JSON.parse(result.body)
        raise(ImgflipApiError, parsed['error_message']) if parsed.keys.include?('error_message')
        image = parsed.fetch('data', {}).fetch('url')
      end

      def self.add_meme(template_id:, pattern:, help:)
        @@_templates << { template_id: template_id, pattern: pattern, help: help }

        route pattern, :make_meme, help: help
      end

      def registered_templates
        self.class.registered_templates
      end

      def self.registered_templates
        @@_templates
      end

      add_meme(template_id: 101470, pattern: /^aliens()\s+(.+)/i, help: 'Ancient aliens guy')
      add_meme(template_id: 61579, pattern: /(one does not simply) (.*)/i, help: 'one does not simply walk into mordor')

      Lita.register_handler(self)
    end
  end
end
