[![Gem Version](https://badge.fury.io/rb/scraperwiki-morph.png)](http://badge.fury.io/rb/scraperwiki-morph)

# ScraperWikiMorph

A simple compatibility layer so that you can use something that looks almost the same as the [ScraperWiki gem](http://rubygems.org/gems/scraperwiki) - the only real difference is that it writes to an sqlite database called `data.sqlite` (rather than ScraperWiki's default `scraperwiki.sqlite`) and a table called `data` (rather than ScraperWiki's default `swdata`)

This makes it very easy to transition scraper code from ScraperWiki to [Morph](http://morph.io)

## Installation

Add this line to your application's Gemfile:

    gem 'scraperwiki-morph'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scraperwiki-morph

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
