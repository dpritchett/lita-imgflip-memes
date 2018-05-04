# from lita-imgflip-memes/spec/lita/handlers/imgflip_memes_spec.rb
it 'can handle two-line inputs' do
  send_message 'lita one does not simply walk into mordor'
  expect(replies.last).to match(jpeg_url_match)
end
