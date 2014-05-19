# LsLinkdirectAPI

Ruby wrapper for [LinkShare LinkLocator Direct](http://helpcenter.linkshare.com/publisher/questions.php?questionid=50).
Supported web services:
  * [TextLinks]
  * [BannerLinks]
  * [DRMLinks]

## Installation

Add this line to your application's Gemfile:

    gem 'ls_linkdirect_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ls_linkdirect_api

## Usage

Before using **LsLinkdirectAPI** you need to set up your publisher token first. If you use Ruby on Rails, the token can be set in a configuration file (i.e. `app/config/initializers/linkshare_api.rb`), otherwise just set it in your script. The token can be found on LinkShare's Web Services page under the Links tab.

Currently there are three services that can be used with this gem.  To use those services, you name the service as the class when you declare a new instance of the class (i.e. `LsLinkdirectAPI::TextLinks.new`) see examples below.

```ruby
require "ls_linkdirect_api" # no need for RoR
LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]
```
### Text Link Request

This request gives you the available text links. To specify the links your request returns, you can filter it using these parameters: MID, Category, Start Date, and End Date.

```ruby
textlinks = LsLinkdirectAPI::TextLinks.new
params = { mid: -1, cat: -1, startDate: 01012014, endDate: 05012014 }
# all params are optional gem will add defaults where required
response = textlinks.get(params)
response.data.each do |item|
  puts "Name: #{item.linkName}"
  puts "Click URL: #{item.clickURL}"
  puts "Tracking Pixil : #{item.showURL}"
  puts "Text Display: #{item.textDisplay}"
end
```
### Banner Link Request

This feed gives you the available banner links. To obtain specific banner links, you can filter this request using these parameters: MID, Category, Size, Start Date, and End Date.

[LinkLocator Direct: Banner Size Codes](http://helpcenter.linkshare.com/publisher/questions.php?questionid=907)

```ruby
bannerlinks = LsLinkdirectAPI:: BannerLinks.new
params = { mid: -1, cat: -1, startDate: 01012014, endDate: 05012014, size: 1  }
# all params are optional gem will add defaults where required
response = bannerlinks.get(params)
response.data.each do |item|
  puts "Name: #{item.linkName}"
  puts "Click URL: #{item.clickURL}"
  puts "Tracking Pixil : #{item.showURL}"
  puts "Text Display: #{item.textDisplay}"
  puts "Image URL: #{item.imgURL}"
end
```

### DRM Link Request
This feed gives you the available DRM links. To obtain specific DRM links, you can filter it using these parameters: MID, Category, Start Date, and End Date.

```ruby
drmlinks = LsLinkdirectAPI:: DRMLinks.new
params = { mid: -1, cat: -1, startDate: 01012014, endDate: 05012014 }
# all params are optional gem will add defaults where required
response = drmlinks.get(params)
response.data.each do |item|
  puts "Name: #{item.linkName}"
  puts "Code: #{item.code}"
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ls_linkdirect_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
