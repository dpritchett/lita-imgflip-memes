require 'pry'
module Lita
  module Handlers
    class ImgflipApiError < Error; end

    class ImgflipMemes < Handler
      config :api_user, default: ENV['IMGFLIP_API_USER']
      config :api_password, default: ENV['IMGFLIP_API_PASSWORD']

      TEMPLATES = [
        { template_id: 101470, pattern: /^aliens()\s+(.+)/i, help: 'Ancient aliens guy' },
        { template_id: 61579, pattern: /(one does not simply) (.*)/i, help: 'one does not simply walk into mordor' },
      ]

      TEMPLATES.each do |t|
        route t.fetch(:pattern), :make_meme, command: true, help: t.fetch(:help)
      end

      def make_meme(message)
        line1, line2 = extract_meme_text(message.match_data)

        template = find_template(message.pattern)
        image = pull_image(template.fetch(:template_id), line1, line2)

        message.reply image
      end

      def extract_meme_text(match_data)
        _, line1, line2 = match_data.to_a
        return line1, line2
      end

      def find_template(pattern)
        template = TEMPLATES.select { |t| t.fetch(:pattern) == pattern }.first
        raise ArgumentError if template.nil?
        return template
      end

      def pull_image(template_id, line1, line2)
        username = config.api_user
        password = config.api_password

        api_url = 'https://api.imgflip.com/caption_image'
        result = http.post api_url, { 
          template_id: template_id,
          username: username,
          password: password,
          text0: line1,
          text1: line2
        } 

        # clean me up
        parsed = JSON.parse(result.body)
        raise(ImgflipApiError, parsed['error_message']) if parsed.keys.include?('error_message')
        image = parsed.fetch('data').fetch('url')
      end

      Lita.register_handler(self)
    end
  end
end
