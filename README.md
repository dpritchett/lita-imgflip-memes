# lita-imgflip-memes

[![Build Status](https://travis-ci.org/dpritchett/lita-imgflip-memes.svg?branch=master)](https://travis-ci.org/dpritchett/lita-imgflip-memes)
[![Coverage Status](https://coveralls.io/repos/dpritchett/lita-imgflip-memes/badge.svg)](https://coveralls.io/r/dpritchett/lita-imgflip-memes)

Add imgflip meme generation to your Lita bot!

![ancient aliens guy saying 'chat bots'](http://i.imgur.com/FxGSzjVl.jpg)

## Installation

Add lita-imgflip-memes to your Lita instance's Gemfile:

``` ruby
gem "lita-imgflip-memes"
```

## Configuration
The 'lita way' to do this is to open up your `lita_config.rb` and set up file-based configuration:

```rb
config.handlers.imgflip_memes.api_user = 'myusername'
config.handlers.imgflip_memes.api_password = 'mypassword'
```

I have set up this gem to deafult to the following environment variables if the config entries aren't set in `lita_config.rb`:

```rb
  ENV['IMGFLIP_API_USER']
  ENV['IMGFLIP_API_PASSWORD']
```

## Usage

```
Lita > lita aliens chatbots
http://i.imgflip.com/1tzqwt.jpg
```
