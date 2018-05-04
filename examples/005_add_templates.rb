# from lita-imgflip-memes/lib/lita/handlers/imgflip_memes.rb
TEMPLATES = [
  { template_id: 101470, pattern: /^aliens()\s+(.+)/i,
    help: 'Ancient aliens guy' },
  { template_id: 61579, pattern: /(one does not simply) (.+)/i,
    help: 'one does not simply walk into mordor' },
]

TEMPLATES.each do |t|
  route t.fetch(:pattern), :make_meme, command: true, help: t.fetch(:help)
end

def make_meme(message)
  match = message.matches.first
  raise ArgumentError unless match.size == 2
  line1, line2 = match

  templates = TEMPLATES.select do |t|
    t.fetch(:pattern) == message.pattern
  end
  template = templates.first

  raise ArgumentError if template.nil?

  image = pull_image(template.fetch(:template_id), line1, line2)

  message.reply image
end
