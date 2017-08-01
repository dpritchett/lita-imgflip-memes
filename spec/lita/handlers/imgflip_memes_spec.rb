require "spec_helper"

describe Lita::Handlers::ImgflipMemes, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  subject { described_class.new(robot) }

  describe 'routes' do
    it { is_expected.to route("Lita aliens chat bots") }
  end

  describe ':make_meme' do
    it 'responds with an image URL' do
      send_message "Lita aliens chat bots"
      expect(replies.last).to match(/http.*jpg/i)
    end
  end
end
