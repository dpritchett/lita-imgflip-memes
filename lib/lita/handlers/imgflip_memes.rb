require 'pry'
module Lita
  module Handlers
    class ImgflipMemes < Handler
      # insert handler code here

      Lita.register_handler(self)


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
        username = ENV.fetch('IMGFLIP_USERNAME', 'memtech_elvis')
        password = ENV.fetch('IMGFLIP_USERNAME', 'memtech_elvis')

        api_url = 'https://api.imgflip.com/caption_image'
        result = http.post api_url, { 
          template_id: template_id,
          username: username,
          password: password,
          text0: line1,
          text1: line2
        } 

        # clean me up
        image = JSON.parse(result.body).fetch("data").fetch("url")
      end
    end
  end
end
