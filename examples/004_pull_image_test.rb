# from lita-imgflip-memes/spec/lita/handlers/imgflip_memes_spec.rb
let(:jpeg_url_match) { /http.*\.jpg/i }

describe ':pull_image' do
  it 'returns a jpeg url' do
    aliens_template_id = 101470
    result = subject.pull_image(aliens_template_id, 'hello', 'world')

    expect(result).to match(jpeg_url_match)
  end
end
