require 'pry'
module Lita
  module Handlers
    class ImgflipMemes < Handler
      # insert handler code here

      Lita.register_handler(self)

      route /^(aliens)\s+(.+)/i, :make_meme, command: true, help: 'Aliens guy meme'

      def make_meme(message)
        template_id = 101470

	# generalize me
	# figure out when i might have multiple matches instead of just :first
	meme_name, text0, text1 = message.matches.first

        image = pull_image(template_id, text0, text1)

	message.reply image
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
