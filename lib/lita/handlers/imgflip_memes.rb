require 'pry'
module Lita
  module Handlers
    class ImgflipMemes < Handler
      # insert handler code here

      Lita.register_handler(self)

      route /^(aliens)\s+(.+)/i, :make_meme, command: true, help: 'Aliens guy meme'

      def make_meme(message)
        template_id = 101470
        username = ENV.fetch('IMGFLIP_USERNAME', 'memtech_elvis')
        password = ENV.fetch('IMGFLIP_USERNAME', 'memtech_elvis')

	# generalize me
	# figure out when i might have multiple matches instead of just :first
	meme_name, text0, text1 = message.matches.first

        api_url = 'https://api.imgflip.com/caption_image'
        result = http.post api_url, { 
          template_id: template_id,
          username: username,
          password: password,
          text0: text0,
          text1: text1
        } 

	# clean me up
	image = JSON.parse(result.body).fetch("data").fetch("url")
	message.reply image
      end
    end
  end
end
