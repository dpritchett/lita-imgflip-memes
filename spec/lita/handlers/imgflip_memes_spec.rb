require "spec_helper"

describe Lita::Handlers::ImgflipMemes, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }
  let(:jpeg_url_match) { /http.*\.jpg/i }
  let(:aliens_template_id) { 101470 }

  subject { described_class.new(robot) }

  describe 'routes' do
    it { is_expected.to route("Lita aliens chat bots") }
  end

  describe ':pull_image' do
    it 'returns a jpeg url' do
      result = subject.pull_image(aliens_template_id, 'hello', 'world')

      expect(result).to match(jpeg_url_match)
    end
  end

  describe ':make_meme' do
    after { send_command "aliens chat bots" }
    it 'responds with an image URL' do
      send_message "Lita aliens chat bots"
      expect(replies.last).to match(jpeg_url_match)
    end


    it 'can handle two-line inputs' do
      send_message 'lita one does not simply walk into mordor'
      expect(replies.last).to match(jpeg_url_match)
    end
  end
end
